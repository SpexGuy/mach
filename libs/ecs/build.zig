const std = @import("std");

pub const pkg = std.build.Pkg{
    .name = "ecs",
    .source = .{ .path = sdkPath("/src/main.zig") },
    .dependencies = &[_]std.build.Pkg{},
};

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&testStep(b, mode, target).step);
}

pub fn testStep(b: *std.build.Builder, mode: std.builtin.Mode, target: std.zig.CrossTarget) *std.build.RunStep {
    const main_tests = b.addTestExe("ecs-tests", sdkPath("/src/main.zig"));
    main_tests.setBuildMode(mode);
    main_tests.setTarget(target);
    main_tests.install();
    return main_tests.run();
}

fn sdkPath(comptime suffix: []const u8) []const u8 {
    if (suffix[0] != '/') @compileError("suffix must be an absolute path");
    return comptime blk: {
        const root_dir = std.fs.path.dirname(@src().file) orelse ".";
        break :blk root_dir ++ suffix;
    };
}
