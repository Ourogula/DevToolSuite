namespace TestApp;

public class Room
{
  public List<VariableAction> events;
  public List<int[]> cells;
  public int id;

  public Room(
    int id,
    List<VariableAction> events,
    List<int[]> cells)
  {
    this.id = id;
    this.events = events;
    this.cells = cells;
  }
}
