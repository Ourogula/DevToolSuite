namespace TestApp;

public class VariableAction
{
  public object[] Args;
  public ParamAction Callback;

  public VariableAction(string name, params object[] args)
  {
    this.Callback = EventActions.Actions[name];
    this.Args = args;
  }
}
