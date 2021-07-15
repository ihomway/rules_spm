load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load(
    "//spm/internal:providers.bzl",
    "create_clang_module",
    "create_copy_info",
    "create_swift_module",
)

def _create_swift_module_test(ctx):
    env = unittest.begin(ctx)

    result = create_swift_module(
        "MyModule",
        ["first.o", "second.o"],
        "MyModule.swiftdoc",
        "MyModule.swiftmodule",
        "MyModule.swiftsourceinfo",
        ["MyModule.h"],
        ["all"],
    )
    expected = struct(
        module_name = "MyModule",
        o_files = ["first.o", "second.o"],
        swiftdoc = "MyModule.swiftdoc",
        swiftmodule = "MyModule.swiftmodule",
        swiftsourceinfo = "MyModule.swiftsourceinfo",
        hdrs = ["MyModule.h"],
        all_outputs = ["all"],
    )
    asserts.equals(env, expected, result)

    return unittest.end(env)

create_swift_module_test = unittest.make(_create_swift_module_test)

def _create_clang_module_test(ctx):
    env = unittest.begin(ctx)

    result = create_clang_module(
        "MyModule",
        ["first.o", "second.o"],
        ["hdrs"],
        "modulemap",
        ["all"],
    )
    expected = struct(
        module_name = "MyModule",
        o_files = ["first.o", "second.o"],
        hdrs = ["hdrs"],
        modulemap = "modulemap",
        all_outputs = ["all"],
    )
    asserts.equals(env, expected, result)

    return unittest.end(env)

create_clang_module_test = unittest.make(_create_clang_module_test)

def _create_copy_test(ctx):
    env = unittest.begin(ctx)

    result = create_copy_info("src", "dest")
    expected = struct(src = "src", dest = "dest")
    asserts.equals(env, expected, result)

    return unittest.end(env)

create_copy_test = unittest.make(_create_copy_test)

def providers_test_suite():
    return unittest.suite(
        "providers_tests",
        create_swift_module_test,
        create_clang_module_test,
        create_copy_test,
    )