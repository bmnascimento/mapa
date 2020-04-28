
import java.util.*;
import java.util.logging.*;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

/**
This class represents a generic JCL statement whose primary purpose is
assisting in symbolic substitution during preprocessing.
*/

public class PPOp {

	private Logger LOGGER = null;
	private TheCLI CLI = null;
	private String myName = null;
	private String myType = null;
	private String fileName = null;
	private String originalText = null;
	private String resolvedText = null;
	/*TODO this probably can be an ArrayList, eliminating the need for
	the equals() and hashCode() methods in PPSymbolic*/
	private HashMap<PPSymbolic, String> symbolics = new HashMap<>();
	private Boolean inProc = false;
	private String procName = null;

	public PPOp(
		JCLPPParser.CommandStatementContext ctx
		, String fileName
		, String procName
		, Logger LOGGER
		, TheCLI CLI
		) {
		this.myType = ctx.getClass().getName();
		this.initialize(fileName, procName, ctx.SYMBOLIC(), LOGGER, CLI);
	}

	public PPOp(
		JCLPPParser.JobCardContext ctx
		, String fileName
		, String procName
		, Logger LOGGER
		, TheCLI CLI
		) {
		this.myType = ctx.getClass().getName();
		this.initialize(fileName, procName, ctx.SYMBOLIC(), LOGGER, CLI);
	}

	public PPOp(
		JCLPPParser.NotifyStatementContext ctx
		, String fileName
		, String procName
		, Logger LOGGER
		, TheCLI CLI
		) {
		this.myType = ctx.getClass().getName();
		this.initialize(fileName, procName, ctx.SYMBOLIC(), LOGGER, CLI);
	}

	public PPOp(
		JCLPPParser.OutputStatementContext ctx
		, String fileName
		, String procName
		, Logger LOGGER
		, TheCLI CLI
		) {
		this.myType = ctx.getClass().getName();
		this.initialize(fileName, procName, ctx.SYMBOLIC(), LOGGER, CLI);
	}

	public PPOp(
		JCLPPParser.ScheduleStatementContext ctx
		, String fileName
		, String procName
		, Logger LOGGER
		, TheCLI CLI
		) {
		this.myType = ctx.getClass().getName();
		this.initialize(fileName, procName, ctx.SYMBOLIC(), LOGGER, CLI);
	}

	public PPOp(
		JCLPPParser.JclCommandStatementContext ctx
		, String fileName
		, String procName
		, Logger LOGGER
		, TheCLI CLI
		) {
		this.myType = ctx.getClass().getName();
		this.initialize(fileName, procName, ctx.SYMBOLIC(), LOGGER, CLI);
	}

	private void initialize(
			String fileName
			, String procName
			, List<org.antlr.v4.runtime.tree.TerminalNode> tn
			, Logger LOGGER
			, TheCLI CLI
			) {
		this.myName = this.getClass().getName();
		this.LOGGER = LOGGER;
		this.CLI = CLI;
		this.fileName = fileName;
		this.inProc = !(procName == null);
		this.procName = procName;
		for (PPSymbolic s: PPSymbolic.bunchOfThese(tn, fileName, procName, LOGGER, CLI)) {
			symbolics.put(s, null);
		}
	}

	/**
	Using the collection of SetSymbolValue passed in, resolve the Symbolic
	values, then store the resolved value locally.
	*/
	public void resolveParms(ArrayList<PPSetSymbolValue> sets) {
		this.LOGGER.finer(this.myName + " " + this.myType + " resolveParms");

		for (PPSymbolic s: this.symbolics.keySet()) {
			s.resolve(sets);
			this.symbolics.put(s, s.getResolvedText());
		}
	}

	/**
	Return the local collection of symbolics.
	*/
	public ArrayList<PPSymbolic> collectSymbolics() {
		this.LOGGER.finer(this.myName + " " + this.myType + " collectSymbolics");

		return new ArrayList<>(this.symbolics.keySet());
	}

	public String toString() {
		StringBuffer buf = new StringBuffer(
			this.myName 
			+ " type = |"
			+ this.myType
			+ " fileName = |" 
			+ this.fileName 
			+ "| procName = |" 
			+ this.procName 
			+ "| symbolics = |" 
			+ symbolics 
			+ "|"
			);

		return buf.toString();
	}

}