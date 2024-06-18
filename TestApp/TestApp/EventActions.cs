namespace TestApp;

public static class EventActions
{
  public static Dictionary<string, ParamAction> Actions = new()
  {
    {"EventA", (a) => { Console.WriteLine("Hello from Event A!"); } },
    {"EventB", (a) => { ActionA((int)a[0]); ActionB((string)a[1]); } },
    {"Hallway", (a) => { Console.WriteLine("Navigating through the hallways."); } },
    {"End", (a) => { Console.WriteLine("Reached the end!"); } }
  };

  private static void ActionA(int number)
  {
    Console.WriteLine($"I have the number {number} as a parameter!");
  }

  private static void ActionB(string word)
  {
    Console.WriteLine($"I have the string {word} as a parameter!");
  }
}
