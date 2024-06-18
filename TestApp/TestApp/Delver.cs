using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace TestApp;

public class Delver
{
  Dictionary<int, Room> rooms = new()
  {
    { 0, new(0, new(), new List<int[]>{new int[]{0,0},
                                    new int[]{0,1},
                                    new int[]{0,3},
                                    new int[]{1,0},
                                    new int[]{1,3},
                                    new int[]{2,2},
                                    new int[]{2,3}}) 
    },
    { 1, new(1, new(), new List<int[]>{new int[]{0,2}}) 
    },
    { 2, new(2, new List<VariableAction>{new ("Hallway")}, new List<int[]>{new int[]{1,1},
                                    new int[]{1,2}})
    },
    { 3, new(3, new(), new List<int[]>{new int[]{2,0},
                                    new int[]{2,1},
                                    new int[]{3,0},
                                    new int[]{3,1}})
    },
    { 4, new(4, new(), new List<int[]>{new int[]{3,2}})
    },
    { 5, new(5, new List<VariableAction>{new ("End") }, new List<int[]>{new int[]{3,3}})
    }
  };

  int start = 1;
  int end = 5;
  bool reachedEnd = false;


  public int NavigatePath()
  {
    int movementCount = 0;
    int[] startingPoint = rooms[start].cells.First();
    int[] currentPoint = startingPoint;
    int[] nextPoint = [0,0];
    Random rand = new Random();
    
    while (!reachedEnd)
    {
      int dir = rand.Next(1, 5);
      switch (dir)
      {
        case 1:
          nextPoint = [currentPoint[0] + 1, currentPoint[1]];
          break;
        case 2:
          nextPoint = [currentPoint[0] - 1, currentPoint[1]];
          break;
        case 3:
          nextPoint = [currentPoint[0], currentPoint[1] + 1];
          break;
        case 4:
          nextPoint = [currentPoint[0], currentPoint[1] - 1];
          break;
      }

      if (!rooms.Values.Where(x => x.id != 0).Any(r => r.cells.Any(c => c.SequenceEqual(nextPoint))))
        continue;
      else
        currentPoint = nextPoint;

      Console.WriteLine($"Currently at cell [{currentPoint[0]},{currentPoint[1]}].");

      foreach (VariableAction item in rooms.Values.Where(r => r.cells.Any(c => c.SequenceEqual(nextPoint))).First().events)
      {
        item.Callback.Invoke(item.Args);
      }

      if (rooms[5].cells.Any(c => c.SequenceEqual(currentPoint)))
        reachedEnd = true;
    }

    return movementCount;
  }

  /*[0][0][3][3]
   *[0][2][3][3] 
   *[1][2][0][4] 
   *[0][0][0][5]
   */
}
