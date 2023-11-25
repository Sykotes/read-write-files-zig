const std = @import("std");

pub fn main() !void {
    const file_name = "test.txt";
    // .mode is how you set the OpenFlags. your options are .read_only .write_only or .read_write
    // if the file can't be opened it sets it to null
    const open_file = std.fs.cwd().openFile(file_name, .{ .mode = .read_write }) catch null;

    // check if file is not null
    if (open_file) |file| {
        // multiline string
        defer file.close();
        const message =
            \\Hello File!
            \\BASED
        ;

        // write to the file
        try file.writeAll(message);

        // go to begining before reading
        try file.seekTo(0);

        var buf_reader = std.io.bufferedReader(file.reader());
        var in_stream = buf_reader.reader();

        // create a buffer for the line
        var buf: [1024]u8 = undefined;
        // loop through lines in file and print them
        while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            std.debug.print("{s}\n", .{line});
        }
    } else {
        // if file is null
        std.debug.print("Failed to open file: {s}\n", .{file_name});
    }
}
