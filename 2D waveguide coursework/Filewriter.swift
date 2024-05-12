import Foundation


public class FileWriter {

    private var path: URL

    private let fileUrl: URL

 

    public init(fileName: String) {

            path = try! FileManager.default.url(for: .documentDirectory,

                                                in: .userDomainMask,

                                                appropriateFor: nil,

                                                create: true)

            fileUrl = path.appendingPathComponent(fileName)

            print("File created in: (fileUrl.path)")

    }

 

    public func write_data(data: String) {

        do {

            try data.write(to: fileUrl,

                           atomically: true,

                           encoding: String.Encoding.utf8)

        } catch  {

            print ("Error, cannot write to file: (fileUrl.lastPathComponent)")

        }

    }

 

    // used code from: https://smashswift.com/how-to-add-text-to-file/

    public func append_data(data: String) {

        if let handle = try? FileHandle(forWritingTo: fileUrl) {

            do {

                try handle.seekToEnd()

                handle.write(data.data(using: .utf8)!)

                handle.closeFile()

            } catch {

                print ("Error, cannot append to file: (fileUrl.lastPathComponent)")

            }

        }

    }

}
