import Foundation


// Define constants and initialize arrays
let sizeX = 200
let sizeY = 200
let maxTime = 500
let imp0 = 377.0

var ez = Array(repeating: Array(repeating: 0.1, count: sizeX), count: sizeY)
var hy = Array(repeating: Array(repeating: 0.2, count: sizeX), count: sizeY)
var hx = Array(repeating: Array(repeating: 0.3, count: sizeX), count: sizeY)
var ex = Array(repeating: Array(repeating: 0.4, count: sizeX), count: sizeY)
var ey = Array(repeating: Array(repeating: 0.5, count: sizeX), count: sizeY)
var hz = Array(repeating: Array(repeating: 0.6, count: sizeX), count: sizeY)

// Time stepping loop
for qTime in 0..<maxTime {
    // Update magnetic field
    for mm in 0..<sizeY - 1 {
        for nn in 0..<sizeX - 1 {
            hy[mm][nn] += (ez[mm + 1][nn] - ez[mm][nn]) / imp0
            hx[mm][nn] -= (ez[mm][nn + 1] - ez[mm][nn]) / imp0
        }
    }

    // Update electric field
    for mm in 1..<sizeY {
        for nn in 1..<sizeX {
            ez[mm][nn] += (hy[mm][nn] - hy[mm][nn - 1]) * imp0
            ex[mm][nn] -= (hy[mm][nn] - hy[mm][nn - 1]) * imp0
            ey[mm][nn] += (hx[mm][nn] - hx[mm - 1][nn]) * imp0
            hz[mm][nn] -= (hx[mm][nn] - hx[mm - 1][nn]) * imp0
        }
    }

    // Use additive source at node (100,100)
    ez[100][100] += exp(-(Double(qTime) - 30.0) * (Double(qTime) - 30.0) / 200.0)

    // Output at specified time step
    if qTime == 110 {
        var output = ""
        for mm in 0..<sizeX {
            for nn in 0..<sizeY {
                let line = "\(mm) \(nn) \(ez[mm][nn]) \(ey[mm][nn]) \(ez[mm][nn]) \(hx[mm][nn]) \(hy[mm][nn]) \(hz[mm][nn])\n"
                output += line
            }
        }

        // Write data to file
        let fileWriter = FileWriter(fileName: "output.dat")
        fileWriter.write_data(data: output)
    }
}
    //change
