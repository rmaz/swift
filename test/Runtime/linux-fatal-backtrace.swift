// RUN: %empty-directory(%t)
// RUN: %target-build-swift %s -o %t/a.out
// RUN: %{python} %S/../Inputs/not.py "%target-run %t/a.out" 2>&1 | PYTHONPATH=%lldb-python-path %{python} %utils/symbolicate-linux-fatal %t/a.out - | %{python} %utils/backtrace-check -u
// REQUIRES: executable_test
// REQUIRES: OS=linux-gnu
// REQUIRES: lldb

// NOTE: not.py is used above instead of "not --crash" because %target-run
// doesn't pass through the crash, and `not` may not be available when running
// on a remote host.

// Backtraces are not emitted when optimizations are enabled. This test can not
// run when optimizations are enabled.
// REQUIRES: swift_test_mode_optimize_none

// SWIFT_ENABLE_TENSORFLOW
// `utils/symbolicate-linux-fatal` fails with TensorFlow support because
// libtensorflow.so is not linked properly. `import lldb` causes an import
// error:
// "ImportError: libtensorflow.so: cannot open shared object file"
// The lldb swig setup scripts should be edited to fix this.
// UNSUPPORTED: tensorflow

func funcB() {
    fatalError("linux-fatal-backtrace");
}

func funcA() {
    funcB();
}

print("bla")
funcA()
