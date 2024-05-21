import Foundation

// Define constants
let SizeX = 101
let SizeY = 81
let MaxTime = 500
let imp0: Double = 377.0
// Add boundary at x = 50
let boundaryX = 20
// Define coefficient arrays
var ceze = Array(repeating: Array(repeating: 0.0, count: SizeY), count: SizeX)
var cezh = Array(repeating: Array(repeating: 0.0, count: SizeY), count: SizeX)
var chxh = Array(repeating: Array(repeating: 0.0, count: SizeY - 1), count: SizeX)
var chxe = Array(repeating: Array(repeating: 0.0, count: SizeY - 1), count: SizeX)
var chyh = Array(repeating: Array(repeating: 0.0, count: SizeY), count: SizeX - 1)
var chye = Array(repeating: Array(repeating: 0.0, count: SizeY), count: SizeX - 1)

// Global variables
private var ppw: Double = 0
private var cdtds: Double = 0.707


var localImpedance = imp0

// Function to initialize the source function
func ezIncInit() {
    ppw = 20
}

// Function to calculate the source function at given time and location
func ezInc(time: Double, location: Double) -> Double {
    return 10*(sin(2.0 * Double.pi / ppw * (cdtds * time - location)))
}

// Set electric-field update coefficients
for mm in 0..<SizeX {
    for nn in 0..<SizeY {
        ceze[mm][nn] = 1.0
        cezh[mm][nn] = cdtds * localImpedance
    }
}

// Set magnetic-field update coefficients
for mm in 0..<SizeX {
    for nn in 0..<(SizeY - 1) {
        if mm == boundaryX {
            
        //}&& (nn > 30 && nn < 35) && (nn < 45 && nn < 50) {
            localImpedance = 2000.0
        }else{
            localImpedance = 377.0
        }
        chxh[mm][nn] = 1.0
        chxe[mm][nn] = cdtds / localImpedance
    
    }
}

for mm in 0..<(SizeX - 1) {
    for nn in 0..<SizeY {
        if mm == boundaryX{
            //&&
            //(nn > 30 && nn < 35) && (nn < 45 && nn < 50) {
            localImpedance = 2000.0
        }else{
            localImpedance = 377.0
        }
        chyh[mm][nn] = 1.0
        chye[mm][nn] = cdtds / localImpedance
    }
}

// Define Grid structure
public struct Grid {
    var Ez: [[Double]]
    var Hx: [[Double]]
    var Hy: [[Double]]
}

// Initialize grid
var g = Grid(Ez: Array(repeating: Array(repeating: -3.0, count: SizeY), count: SizeX),
             Hx: Array(repeating: Array(repeating: 0.0, count: SizeY - 1), count: SizeX),
             Hy: Array(repeating: Array(repeating: 0.0, count: SizeY), count: SizeX - 1))
func updateH2d() {
    for mm in 0..<(SizeX - 1) {
        for nn in 0..<(SizeY - 1) {
            // Check if the current point is not within any of the boundary ranges
          
            g.Hx[mm][nn] = g.Hx[mm][nn] - chye[mm][nn] * (g.Ez[mm][nn + 1] - g.Ez[mm][nn])
        }
    }
    
    for mm in 0..<(SizeX - 1) {
        for nn in 0..<SizeY  {
            // Check if the current point is not within any of the boundary ranges
            
            g.Hy[mm][nn] = chyh[mm][nn] * g.Hy[mm][nn] + chye[mm][nn] * (g.Ez[mm + 1][nn] - g.Ez[mm][nn])
        }
    }
}

// Define updateE2d function
func updateE2d() {
    for mm in 1..<(SizeX - 1) {
        for nn in 1..<(SizeY - 1) {
            // Check if the current point is not within any of the boundary ranges
            g.Ez[mm][nn] = ceze[mm][nn] * g.Ez[mm][nn] +
                cezh[mm][nn] * ((g.Hy[mm][nn] - g.Hy[mm - 1][nn]) - (g.Hx[mm][nn] - g.Hx[mm][nn - 1]))
        }
    }
}

    
    
    // Main simulation code
    ezIncInit()
    
    // Add source node
    g.Ez[0][SizeY / 2] = 0

    
    
    
   /*
    let boundaryY1Start = 0
    let boundaryY1End = 30
    
    // Add boundary between y = 0 and y = 30
    for yy in boundaryY1Start..<boundaryY1End {
        g.Ez[boundaryX][yy] = 0.0 // Set Ez to 0 for y values between 0 and 30 at x = 50
    }
    let boundaryY2Start = 50
    let boundaryY2End = 80
    
    // Add boundary between y = 0 and y = 30
    for yy in boundaryY2Start..<boundaryY2End {
        g.Ez[boundaryX][yy] = 0.0 // Set Ez to 0 for y values between 0 and 30 at x = 50
    }
    let boundaryY3Start = 35
    let boundaryY3End = 39
    
    // Add boundary between y = 0 and y = 30
    for yy in boundaryY3Start..<boundaryY3End {
        g.Ez[boundaryX][yy] = 0.0 // Set Ez to 0 for y values between 0 and 30 at x = 50
    }
    let boundaryY4Start = 41
    let boundaryY4End = 45

    // Add boundary between y = 0 and y = 30
for yy in boundaryY4Start ..< boundaryY4End {
        g.Ez[boundaryX][yy] = 0.0 // Set Ez to 0 for y values between 0 and 30 at x = 50
    }
    */
    // Do time stepping
    for Time in 0..<MaxTime {
        // Update magnetic field
        updateH2d()
        
        // Update electric field
        updateE2d()
        
        // Output at specified time step
        if Time % 1 == 0 {
            var output = ""
            for mm in 0..<SizeX {
                for nn in 0..<SizeY {
                    let line = "\(mm) \(nn) \(g.Ez[mm][nn])\n"
                    output += line
                }
            }
            
            // Write data to file
            let filename = "output\(Time + 1).dat"
            let fileWriter = FileWriter(fileName: filename)
            fileWriter.write_data(data: output)
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     func updateH2d() {
     for mm in 0..<(SizeX - 1) {
     for nn in 0..<(SizeY - 1) {
     // Check if the current point is a boundary point
     if mm != boundaryX && mm + 1 != boundaryX {
     g.Hx[mm][nn] = g.Hx[mm][nn] - chye[mm][nn] * (g.Ez[mm][nn + 1] - g.Ez[mm][nn])
     }
     }
     }
     
     for mm in 0..<(SizeX - 1) {
     for nn in 0..<SizeY  {
     // Check if the current point is a boundary point
     if mm != boundaryX && mm + 1 != boundaryX {
     g.Hy[mm][nn] = chyh[mm][nn] * g.Hy[mm][nn] + chye[mm][nn] * (g.Ez[mm + 1][nn] - g.Ez[mm][nn])
     }
     }
     }
     }
     
     // Define updateE2d function
     func updateE2d() {
     for mm in 1..<(SizeX - 1) {
     for nn in 1..<(SizeY - 1) {
     // Check if the current point is a boundary point
     if nn != boundaryX {
     g.Ez[mm][nn] = ceze[mm][nn] * g.Ez[mm][nn] +
     cezh[mm][nn] * ((g.Hy[mm][nn] - g.Hy[mm - 1][nn]) - (g.Hx[mm][nn] - g.Hx[mm][nn - 1]))
     }
     }
     }
     }
     
     
     // Main simulation code
     ezIncInit()
     
     // Add source node
     g.Ez[0][SizeY / 2] = 0
     
     // Add boundary at x = 50
     let boundaryX = 20
     
     
     let boundaryY1Start = 0
     let boundaryY1End = 30
     
     // Add boundary between y = 0 and y = 30
     for yy in boundaryY1Start..<boundaryY1End {
     g.Ez[boundaryX][yy] = 0.0 // Set Ez to 0 for y values between 0 and 30 at x = 50
     }
     let boundaryY2Start = 50
     let boundaryY2End = 80
     
     // Add boundary between y = 0 and y = 30
     for yy in boundaryY2Start..<boundaryY2End {
     g.Ez[boundaryX][yy] = 0.0 // Set Ez to 0 for y values between 0 and 30 at x = 50
     }
     /*let boundaryY3Start = 35
      let boundaryY3End = 45
      
      // Add boundary between y = 0 and y = 30
      for yy in boundaryY3Start..<boundaryY3End {
      g.Ez[boundaryX][yy] = 0.0 // Set Ez to 0 for y values between 0 and 30 at x = 50
      }
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      // Define a function to check if a grid point is within the hardcoded region
      func isInHardcodedRegion(x: Int, y: Int) -> Bool {
      // Define the boundaries of the hardcoded region
      let minX = 10
      let maxX = 20
      let minY = 5
      let maxY = 15
      
      // Check if the point is within the boundaries
      return x >= minX && x <= maxX && y >= minY && y <= maxY
      }
      
      // Update function for Hx
      func updateHx() {
      for x in 0..<(SizeX - 1) {
      for y in 0..<(SizeY - 1) {
      // Check if the point is not in the hardcoded region
      if !isInHardcodedRegion(x: x, y: y) {
      // Update Hx normally
      // g.Hx[x][y] = ...
      } else {
      // Set the value of Hx in the hardcoded region
      g.Hx[x][y] = 0.0 // Set to any desired value
      }
      }
      }
      }
      
      // Update function for Hy
      func updateHy() {
      for x in 0..<SizeX {
      for y in 0..<SizeY {
      // Check if the point is not in the hardcoded region
      if !isInHardcodedRegion(x: x, y: y) {
      // Update Hy normally
      // g.Hy[x][y] = ...
      } else {
      // Set the value of Hy in the hardcoded region
      g.Hy[x][y] = 0.0 // Set to any desired value
      }
      }
      }
      }
      
      // Update function for Ez
      func updateEz() {
      for x in 0..<SizeX {
      for y in 0..<SizeY {
      // Check if the point is not in the hardcoded region
      if !isInHardcodedRegion(x: x, y: y) {
      // Update Ez normally
      // g.Ez[x][y] = ...
      } else {
      // Set the value of Ez in the hardcoded region
      g.Ez[x][y] = 0.0 // Set to any desired value
      }
      }
      }
      }
      
      */*/
