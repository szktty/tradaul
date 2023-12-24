import 'assignment_test.dart';
import 'binary_operator_test.dart';
import 'conditional_test.dart';
import 'coroutine_test.dart';
import 'do_test.dart';
import 'function_test.dart';
import 'generic_for_test.dart';
import 'goto_test.dart';
import 'init_context.dart';
import 'literal_test.dart';
import 'method_test.dart';
import 'numeric_for_test.dart';
import 'repeat_test.dart';
import 'table_constructor_test.dart';
import 'unary_operator_test.dart';
import 'var_access_test.dart';
import 'while_loop_test.dart';

void main() {
  testInitContext();
  testAssignment();
  testFunctionDefinition();
  testLocalFunctionDefinition();
  testMethodDefinition();

  testInitContext();

  testLiterals();
  testTableConstructors();

  testUnaryOperators();
  testBinaryArithmeticOperators();
  testBinaryBitwiseOperators();
  testBinaryRelationalOperators();
  testBinaryLogicalOperators();
  testBinaryOtherOperators();
  testOperatorPrecedence();

  testLocalAssignment();
  testAssignment();
  testGlobalVariableAccess();
  testTableFieldAccess();
  testFunctionCall();

  testDoBlock();
  testGoto();
  testConditional();
  testWhileLoop();
  testRepeatLoop();
  testNumericForLoop();
  testGenericForLoop();

  testFunctionDefinition();
  testLocalFunctionDefinition();
  testMethodDefinition();

  testCoroutine();
  testCustomCoroutine();
}
