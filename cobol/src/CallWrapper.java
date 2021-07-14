
import java.util.*;
import java.io.*;
import java.nio.file.*;
import java.util.logging.Logger;
import org.antlr.v4.runtime.tree.*;

/**
Despite its name, this class is a wrapper around several different
types of "call," a COBOL CALL (static or dynamic), an EXEC SQL CALL, 
an EXEC CICS LINK or XCTL.

Much code is devoted to dealing with constructs such as...
<code>
01  CALLED-PROGRAMS.
    05  PGM1 PIC X(8) VALUE 'ZHAAN'.
        88  PGM1-A    VALUE 'STARK'.
    05  PGM2 PIC X(8) VALUE 'RYGEL'.
    05  PGM3 PIC X(8) VALUE 'PILOT'.

    CALL PGM1
    EXEC CICS LINK PROGRAM(PGM2) END-EXEC
    EXEC CICS XCTL PROGRAM(PGM3) END-EXEC
    SET PGM1-A TO TRUE
    MOVE 'NORANTI' TO PGM2
    MOVE 'JOOL' TO PGM3
    CALL PGM2
    EXEC CICS LINK PROGRAM(PGM3) END-EXEC
    EXEC CICS XCTL PROGRAM(PGM1) END-EXEC
</code>
*/

class CallWrapper {

	private String myName = this.getClass().getName();
	public UUID uuid = UUID.randomUUID();
	private Logger LOGGER = null;
	public CallType callType = null;
	public String cobolIdentifier = null;
	private Identifier identifier = null;
	private ArrayList<UUID> calledModuleUUIDs = new ArrayList<>();
	private List<String> calledModuleNames = new ArrayList<>();
	public String callingModuleName = null;
	public List<DDNode> eightyEights = new ArrayList<>();
	public ArrayList<String> subNames = null;
	public List<CobolParser.SubscriptContext> subctxs = null;
	public List<CobolParser.QualifiedInDataContext> inDataCtxs = null;
	public ArrayList<String> ofs = new ArrayList<>();
	public CobolParser.CallStatementContext ctxCall = null;
	public CobolParser.ExecCicsStatementContext ctxCics = null;
	private ExecCicsStatement execCicsStmt = null;
	private DB2zCallStatement db2Call = null;
	private String db2CallHostStructure = null;
	public CobolParser.IdentifierContext idCtx = null;
	public DDNode dataNode = null;
	public int line = -1;
	public String aLib = null;
	private ArrayList<QualifiedInData> qualInData = null;

	public CallWrapper(
			CobolParser.CallStatementContext ctx
			, String callingModuleName
			, String aLib
			, Logger LOGGER
			) {
		this.ctxCall = ctx;
		this.LOGGER = LOGGER;
		this.callingModuleName = callingModuleName;
		this.aLib = aLib;
		this.initialize(ctx);
	}

	public CallWrapper(
			CobolParser.ExecCicsStatementContext ctx
			, String callingModuleName
			, String aLib
			, Logger LOGGER
			) {
		this.ctxCics = ctx;
		this.LOGGER = LOGGER;
		this.callingModuleName = callingModuleName;
		this.aLib = aLib;
		this.execCicsStmt = new ExecCicsStatement(ctx, LOGGER);
		this.initialize(ctx);
	}

	public CallWrapper(
			DB2zCallStatement db2Call
			, String callingModuleName
			, String aLib
			, Logger LOGGER
			) {
		this.db2Call = db2Call;
		this.LOGGER = LOGGER;
		this.callingModuleName = callingModuleName;
		this.aLib = aLib;
		this.initialize(db2Call);
	}

	public void addCalledModuleName(String calledModuleName) {
		if (calledModuleName != null) {
			String aString = calledModuleName.replace("'", "");
			aString = aString.replace("\"", "");
			if (!this.includes(calledModuleName)) {
				this.calledModuleNames.add(aString);
				this.calledModuleUUIDs.add(UUID.randomUUID());
			}
		}
		return;
	}

	/**
	Only unique CALLs (et. al.) are interesting.  If the source contains
	multiple CALLs to the same identifier, it's not necessary to record that.

	<p>Determining if the identifier is the same in this context means 
	verifying the call type is the same, the identifier has the same name,
	and its qualifiers (the "ofs" such as X OF Y OF Z) are the same.
	*/
	public Boolean seemsLike(CallWrapper cw) {
		Boolean is = this.callingModuleName.equals(cw.callingModuleName);
		is = is && this.callType == cw.callType;
		if (is && (this.callType == CallType.CALLBYLITERAL
					|| this.callType == CallType.CICSLINKBYLITERAL
					|| this.callType == CallType.CICSXCTLBYLITERAL
					|| this.callType == CallType.SQLCALLBYLITERAL)
					) {
			is = is && this.calledModuleNames.equals(cw.calledModuleNames);
		} else {
			if (this.getCobolIdentifier() != null && cw.getCobolIdentifier() != null) {
				is = is && this.getCobolIdentifier().equals(cw.getCobolIdentifier());
			}
		}
		is = is && this.ofs.equals(cw.ofs);
		return is; 
	}

	/**
	The CALL statement represented by this instance may be of the form
	CALL <i>identifier</i> where <i>identifier</i> is a field name possibly qualified
	by a QualifiedInDataContext.  A concrete example might take the form
	CALL PGM OF ACCOUNT OF SAVINGS.

	<p>This method runs through a List of DDNode instances, each of which
	represents an identifier in the Data Division, attempting to match
	the <i>identifier</i> and its optional QualifiedInDataContext.
	*/

	public Boolean selectDataNode(List<DDNode> dataNodes) {
		this.LOGGER.fine(this.myName + " " + this.callType + " @ " + this.line + " selectDataNode()");
		this.LOGGER.finest("  dataNodes = " + dataNodes);
		Boolean found = false;

		for (DDNode node: dataNodes) {
			if (node.getIdentifier().equals(this.getCobolIdentifier())) {
				if (this.ofs.size() == 0) {
					found = true;
					this.dataNode = node;
					this.addCalledModuleName(this.dataNode.valueInValueClause);
					break;
				} else {
					DDNode parent = node.parent;
					Boolean foundOf = true;
					for (String of: this.ofs) {
						while (parent != null && !parent.getIdentifier().equals(of)) {
							parent = parent.parent;
						}
						if (parent == null) {
							foundOf = false;
							break;
						}
					}
					found = foundOf;
					if (found) {
						this.dataNode = node;
						this.addCalledModuleName(this.dataNode.valueInValueClause);
						break;
					}
				}
			}
		}

		if (this.dataNode == null) {
		} else {
			this.LOGGER.fine(
				"valueInValueClause = |" +
				 this.dataNode.valueInValueClause + "|");
			if (this.dataNode.valueInValueClause == null) {
				this.LOGGER.fine("valueInValueClause == null");
				if (this.dataNode.redefinesIdentifier != null) {
					this.LOGGER.fine(
						"redefinesIdentifier = " 
						+ this.dataNode.redefinesIdentifier);
					List<DDNode> list = 
						this.dataNode.parent.findChildrenNamed(
							this
							.dataNode
							.redefinesIdentifier);
					this.LOGGER.fine("list.size() = " + list.size());
					if (list.size() > 0) {
						this.addCalledModuleName(list.get(0).valueInValueClause);
					}
				}
			}
		}

		return found;
	}

	public Boolean identifierMatches(Identifier identifier) {
		return this.getIdentifier().seemsToMatch(identifier);
	}

	private void initialize(CobolParser.CallStatementContext ctx) {
		this.line = ctx.start.getLine();
		this.initialize(
			ctx.literal()
			, ctx.identifier()
			, CallType.CALLBYLITERAL
			, CallType.CALLBYIDENTIFIER
			);
	}

	public void initialize(CobolParser.ExecCicsStatementContext ctx) {
		this.line = ctx.start.getLine();
		CallType lit = null;
		CallType id = null;

		if (this.execCicsStmt.getType() == ExecCicsStatementType.CICSLINK) {
			lit = CallType.CICSLINKBYLITERAL;
			id = CallType.CICSLINKBYIDENTIFIER;
		} else {
			lit = CallType.CICSXCTLBYLITERAL;
			id = CallType.CICSXCTLBYIDENTIFIER;
		}
		this.initialize(
			this.execCicsStmt.getProgram().getLiteralContext()
			, this.execCicsStmt.getProgram().getIdentifierContext()
			, lit
			, id
			);
	}

	public void initialize(DB2zCallStatement db2Call) {
		this.line = db2Call.getLine();
		if (db2Call.getModuleName() != null ) {
			// CALL literal syntax
			this.addCalledModuleName(db2Call.getModuleName());
			this.callType = CallType.SQLCALLBYLITERAL;
		} else {
			// CALL [hostStructure.]identifier syntax
			ArrayList<String> reply = db2Call.getVariableName();
//			this.addCalledModuleName(reply.get(0));
			this.cobolIdentifier = reply.get(0);
			if (reply.size() > 1) {
				this.ofs.add(reply.get(1));
			}
			this.callType = CallType.SQLCALLBYIDENTIFIER;
		}
	}

	private void initialize(
			CobolParser.LiteralContext litCtx
			, CobolParser.IdentifierContext idCtx
			, CallType litCallType
			, CallType idCallType
			) {
		if ( idCtx == null ) {
			// CALL literal syntax
			if (litCtx == null) {
				// ExecSqlCallStatementContext is handled on its own
			} else {
				this.addCalledModuleName(
					litCtx
					.NONNUMERICLITERAL()
					.toString());
				this.callType = litCallType;
			}
		} else {
			this.idCtx = idCtx;
			this.identifier = new Identifier(idCtx, this.LOGGER);
			this.callType = idCallType;
			if (idCtx.qualifiedDataName() == null ) {
				// CALL identifier(subscript) syntax (sneaky)
				this.cobolIdentifier = 
					idCtx
					.tableCall()
					.qualifiedDataName()
					.qualifiedDataNameFormat1()
					.dataName()
					.cobolWord()
					.IDENTIFIER()
					.toString();
				this.subctxs = idCtx.tableCall().subscript();
				this.subNames = new ArrayList<>();
				for (CobolParser.SubscriptContext sub: subctxs) {
					this.subNames.add(
						sub
						.qualifiedDataName()
						.qualifiedDataNameFormat1()
						.dataName()
						.cobolWord()
						.IDENTIFIER()
						.toString());
				}
				this.inDataCtxs = 
					idCtx
					.tableCall()
					.qualifiedDataName()
					.qualifiedDataNameFormat1()
					.qualifiedInData(); //TODO no longer needed?
			} else {
				// CALL identifier syntax
				this.cobolIdentifier = 
					idCtx
					.qualifiedDataName()
					.qualifiedDataNameFormat1()
					.dataName()
					.cobolWord()
					.IDENTIFIER()
					.toString();
				this.qualInData = QualifiedInData.bunchOfThese(
					idCtx
					.qualifiedDataName()
					.qualifiedDataNameFormat1()
					.qualifiedInData()
					, this.LOGGER);
				if (this.qualInData != null) {
					for (QualifiedInData qind: this.qualInData) {
						this.ofs.add(qind.getText());
					}
				}
			}
		}


	}

	public Boolean includes(String callee) {
		return this.calledModuleNames.contains(callee);
	}

	public Boolean includes(String caller, String callee) {
		return (this.calledModuleNames.contains(callee) 
				&& this.callingModuleName.equals(caller));
	}

	public Boolean includes(String caller, String callee, CallType ty) {
		/**/
		this.LOGGER.fine(
			"this.calledModuleNames.contains(callee) = " 
			+ this.calledModuleNames.contains(callee));
		this.LOGGER.fine("calledModuleNames = " + calledModuleNames);
		this.LOGGER.fine(
			"this.callingModuleName.equals(caller) = " 
			+ this.callingModuleName.equals(caller));
		this.LOGGER.fine("callingModuleName = " + callingModuleName);
		this.LOGGER.fine("caller = " + caller);
		this.LOGGER.fine("this.callType = " + this.callType);
		this.LOGGER.fine("ty = " + ty);
		/**/

		return (this.calledModuleNames.contains(callee) 
				&& this.callingModuleName.equals(caller) && this.callType == ty);
	}

	public String toString() {
		switch (callType) {
			case CALLBYLITERAL:
				return callingModuleName + " CALL literal @" + this.line + ": " + this.calledModuleNames;
			case CICSLINKBYLITERAL:
				return callingModuleName + " CICS LINK literal @" + this.line + ": " + this.calledModuleNames;
			case CICSXCTLBYLITERAL:
				return callingModuleName + " CICS XCTL literal @" + this.line + ": " + this.calledModuleNames;
			case SQLCALLBYLITERAL:
				return callingModuleName + " SQL CALL literal @" + this.line + ": " + this.calledModuleNames;
			case CALLBYIDENTIFIER:
				if (this.subNames == null) {
					return callingModuleName + " CALL identifier @" + this.line + ": " + this.getCobolIdentifier() + " " + this.calledModuleNames;
				} else {
					return callingModuleName + " CALL identifier @" + this.line + ": " + this.getCobolIdentifier() + " subs " + this.subNames;
				}
			case CICSLINKBYIDENTIFIER:
				if (this.subNames == null) {
					return callingModuleName + " CICS LINK identifier @" + this.line + ": " + this.getCobolIdentifier() + " " + this.calledModuleNames;
				} else {
					return callingModuleName + " CICS LINK identifier @" + this.line + ": " + this.getCobolIdentifier() + " subs " + this.subNames;
				}
			case CICSXCTLBYIDENTIFIER:
				if (this.subNames == null) {
					return callingModuleName + " CICS XCTL identifier @" + this.line + ": " + this.getCobolIdentifier() + " " + this.calledModuleNames;
				} else {
					return callingModuleName + " CICS XCTL identifier @" + this.line + ": " + this.getCobolIdentifier() + " subs " + this.subNames;
				}
			case SQLCALLBYIDENTIFIER:
				if (this.subNames == null) {
					return callingModuleName + " SQL CALL identifier @" + this.line + ": " + this.getCobolIdentifier() + " " + this.calledModuleNames;
				} else {
					return callingModuleName + " SQL CALL identifier @" + this.line + ": " + this.getCobolIdentifier() + " subs " + this.subNames;
				}
			default:
				return callingModuleName + " CALL of indeterminate nature";
		}
	}

	public UUID getUUID() {
		return this.uuid;
	}

	public String getCallingModuleName() {
		return this.callingModuleName;
	}

	public String getCobolIdentifier() {
		return this.cobolIdentifier;
	}

	public DDNode getDataNode() {
		return this.dataNode;
	}

	public Identifier getIdentifier() {
		return this.identifier;
	}

	public List<String> getCalledModuleNames() {
		return this.calledModuleNames;
	}

	public void writeOn(PrintWriter out, UUID parentUUID) throws IOException {
		for (int i = 0; i < calledModuleNames.size(); i++) {
			out.printf(
				"CALL,%s,%s,%s,%s,%s\n"
				, calledModuleUUIDs.get(i)
				, parentUUID.toString()
				, this.callingModuleName
				, this.callType
				, calledModuleNames.get(i));
		}

	}
}
