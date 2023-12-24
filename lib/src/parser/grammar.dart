import 'package:petitparser/petitparser.dart';

class LuaBasicGrammarDefinition extends GrammarDefinition {
  Parser _token(Object input, bool trim) {
    if (input is Parser) {
      if (trim) {
        return input.token().trim(ref0(ignore));
      } else {
        return input.token();
      }
    } else if (input is String) {
      return _token(input.toParser(), trim);
    }
    throw ArgumentError.value(input, 'Invalid token parser');
  }

  Parser token(Object input) {
    return ref2(_token, input, true);
  }

  Parser rawToken(Object input) {
    return ref2(_token, input, false);
  }

  Parser ignore() => whitespace().plus();

  @override
  Parser start() => whitespace().star().end();
}

class LuaIdentifierGrammarDefinition extends LuaBasicGrammarDefinition {
  @override
  Parser start() => ref0(name).end();

  Parser name() {
    const reservedWords = [
      'and',
      'break',
      'do',
      'else',
      'elseif',
      'end',
      'false',
      'for',
      'function',
      'goto',
      'if',
      'in',
      'local',
      'nil',
      'not',
      'or',
      'repeat',
      'return',
      'then',
      'true',
      'until',
      'while',
    ];

    final Parser identifierParser =
        ((letter() | char('_')) & (letter() | digit() | char('_')).star())
            .flatten();

    return token(
      identifierParser.where((token) => !reservedWords.contains(token)),
    );
  }
}

class LuaLiteralGrammarDefinition extends LuaIdentifierGrammarDefinition {
  @override
  Parser start() => ref0(literal).end();

  Parser literal() =>
      ref0(literalNil) |
      ref0(literalFalse) |
      ref0(literalTrue) |
      ref0(numeral) |
      ref0(literalString) |
      ref0(tableConstructor);

  Parser literalNil() => token('nil');

  Parser literalTrue() => token('true');

  Parser literalFalse() => token('false');

  Parser numeral() => ref0(float) | ref0(integer);

  Parser integer() => ref0(hexdecimalInteger) | ref0(decimalInteger);

  Parser decimalInteger() => pattern('0-9').plus();

  Parser hexdecimalInteger() =>
      char('0') & pattern('xX') & ref0(hexdecimalIntegerCharacter).plus();

  Parser hexdecimalIntegerCharacter() => pattern('0-9a-fA-F');

  Parser float() => ref0(hexdecimalFloat) | ref0(decimalFloat);

  Parser decimalFloat() =>
      ref0(decimalFloat1) | ref0(decimalFloat2) | ref0(decimalFloat3);

  Parser decimalFloat1() =>
      digit().plus() &
      char('.') &
      digit().star() &
      ref0(decimalFloatExponent).optional();

  Parser decimalFloat2() =>
      digit().star() &
      char('.') &
      digit().plus() &
      ref0(decimalFloatExponent).optional();

  Parser decimalFloat3() => digit().plus() & ref0(decimalFloatExponent);

  Parser decimalFloatExponent() =>
      pattern('eE') & pattern('+-').optional() & digit().plus();

  Parser hexdecimalFloat() =>
      ref0(hexdecimalFloat1) |
      ref0(hexdecimalFloat2) |
      ref0(hexdecimalFloat3) |
      ref0(hexdecimalFloat4);

  Parser hexdecimalFloat1() =>
      char('0') &
      pattern('xX') &
      ref0(hexdecimalIntegerCharacter).plus() &
      char('.') &
      ref0(hexdecimalIntegerCharacter).star() &
      ref0(hexdecimalFloatExponent).optional();

  Parser hexdecimalFloat2() =>
      char('0') &
      pattern('xX') &
      ref0(hexdecimalIntegerCharacter).star() &
      char('.') &
      ref0(hexdecimalIntegerCharacter).plus() &
      ref0(hexdecimalFloatExponent).optional();

  Parser hexdecimalFloat3() =>
      char('0') &
      pattern('xX') &
      ref0(hexdecimalIntegerCharacter).star() &
      char('.') &
      ref0(hexdecimalIntegerCharacter).star() &
      ref0(hexdecimalFloatExponent);

  Parser hexdecimalFloat4() =>
      char('0') &
      pattern('xX') &
      ref0(hexdecimalIntegerCharacter).plus() &
      ref0(hexdecimalFloatExponent);

  Parser hexdecimalFloatExponent() =>
      pattern('pP') & pattern('+-').optional() & digit().star();

  // literal string

  Parser escapeSequence() =>
      char(r'\') &
      (char('a') |
          char('b') |
          char('f') |
          char('n') |
          char('r') |
          char('t') |
          char('v') |
          char(r'\') |
          char('"') |
          char("'") |
          (char('z') & whitespace().star()) |
          (char('x') & ref0(hexdecimalIntegerCharacter).times(2)) |
          (digit().repeat(1, 3)) |
          (char('u') &
              token('{') &
              ref0(hexdecimalIntegerCharacter).plus() &
              token('}')) |
          newline());

  Parser nonEscapeSequence(Parser quote) => (char(r'\') | quote).neg();

  Parser literalStringBody(Parser quote) =>
      (ref1(nonEscapeSequence, quote) | ref0(escapeSequence)).star();

  Parser singleQuote = char("'");

  Parser doubleQuote = char('"');

  Parser singleQuoteShortLiteralString() =>
      (singleQuote & ref1(literalStringBody, singleQuote) & singleQuote)
          .flatten();

  Parser doubleQuoteShortLiteralString() =>
      (doubleQuote & ref1(literalStringBody, doubleQuote) & doubleQuote)
          .flatten();

  Parser shortLiteralString() =>
      ref0(singleQuoteShortLiteralString) | ref0(doubleQuoteShortLiteralString);

  Parser longOpenBracket(int level) =>
      char('[') & char('=').times(level) & char('[');

  Parser longCloseBracket(int level) =>
      char(']') & char('=').times(level) & char(']');

  Parser longLiteralString(int level) =>
      ref1(longOpenBracket, level) &
      (whitespace() | newline() | ref1(longCloseBracket, level).neg()).star() &
      ref1(longCloseBracket, level);

  Parser invalidLongLiteralString() =>
      token('[') & char('=').star() & char('[') & any().star().end();

  Parser literalString() {
    var p = ref1(longLiteralString, 0);
    for (var i = LuaGrammarDefinition.supportedLongBracketLevel; i > 0; i--) {
      p = p | ref1(longLiteralString, i);
    }
    return p | ref0(invalidLongLiteralString) | ref0(shortLiteralString);
  }

  Parser tableConstructor() =>
      token('{') & ref0(fieldList).optional() & token('}');

  Parser fieldList() =>
      ref0(field) &
      (ref0(fieldSep) & ref0(field)).star() &
      ref0(fieldSep).optional();

  // field ::= ‘[’ exp ‘]’ ‘=’ exp | Name ‘=’ exp | exp
  Parser field() => ref0(indexedField) | ref0(namedField) | ref0(valueField);

  Parser indexedField() =>
      token('[') &
      ref0(fieldValue) &
      token(']') &
      token('=') &
      ref0(fieldValue);

  Parser namedField() => ref0(name) & token('=') & ref0(fieldValue);

  Parser valueField() => ref0(fieldValue);

  // subclasses must override this
  Parser fieldValue() => ref0(literal);

  Parser fieldSep() => token(',') | token(';');
}

class LuaPrimaryExpGrammarDefinition extends LuaLiteralGrammarDefinition {
  @override
  Parser start() => ref0(primaryExp).end();

  // instead of original grammar 'prefixexp'
  // petitparser cannot parse left recursive grammar
  // primaryexp ::= (Name | ‘(’ exp ‘)’) {‘[’ exp ‘]’ | ‘.’ Name | args | ‘:’ Name args}
  Parser primaryExp() =>
      (ref0(name) | ref0(wrappedExp)) &
      (ref0(subscript) | ref0(varPath) | ref0(args) | ref0(methodCall)).star();

  Parser wrappedExp() => token('(') & ref0(exp) & token(')');

  Parser varPath() => token('.') & ref0(name);

  Parser subscript() => token('[') & ref0(exp) & token(']');

  Parser methodCall() => token(':') & ref0(name) & ref0(args);

  Parser args() => ref0(expArgs) | ref0(singleArg);

  Parser expArgs() => token('(') & ref0(expList).optional() & token(')');

  Parser singleArg() => ref0(tableConstructor) | ref0(literalString);

  // subclasses must override this
  Parser exp() => ref0(expBase);

  // subclasses must override this
  Parser expBase() => ref0(literal) | ref0(primaryExp) | ref0(varArg);

  Parser varArg() => token('...');

  Parser expList() => ref0(exp).plusSeparated(token(','));
}

class LuaExpGrammarDefinition extends LuaPrimaryExpGrammarDefinition {
  @override
  Parser start() => ref0(exp).end();

  @override
  Parser exp() => ref0(logicalOrExp);

  Parser logicalOrExp() =>
      ref0(logicalAndExp) & (token('or') & ref0(logicalAndExp)).star();

  Parser logicalAndExp() =>
      ref0(relationalExp) & (token('and') & ref0(relationalExp)).star();

  Parser relationalExp() =>
      ref0(bitwiseOrExp) & (ref0(relationalOp) & ref0(bitwiseOrExp)).star();

  Parser relationalOp() =>
      token('<=') |
      token('>=') |
      token('<') |
      token('>') |
      token('~=') |
      token('==');

  Parser bitwiseOrExp() =>
      ref0(bitwiseXorExp) & (token('|') & ref0(bitwiseXorExp)).star();

  Parser bitwiseXorExp() =>
      ref0(bitwiseAndExp) & (token('~') & ref0(bitwiseAndExp)).star();

  Parser bitwiseAndExp() =>
      ref0(shiftExp) & (token('&') & ref0(shiftExp)).star();

  Parser shiftExp() =>
      ref0(concatenationExp) & (ref0(shiftOp) & ref0(concatenationExp)).star();

  Parser shiftOp() => token('<<') | token('>>');

  Parser concatenationExp() =>
      ref0(additiveExp) & (token('..') & ref0(concatenationExp)).optional();

  Parser additiveExp() =>
      ref0(multiplicativeExp) &
      (ref0(additiveOp) & ref0(multiplicativeExp)).star();

  Parser additiveOp() => token('+') | token('-');

  Parser multiplicativeExp() =>
      ref0(unaryExp) & (ref0(multiplicativeOp) & ref0(unaryExp)).star();

  Parser multiplicativeOp() =>
      token('*') | token('//') | token('/') | token('%');

  Parser unaryExp() => ref0(unaryOp).star() & ref0(powerExp);

  Parser unaryOp() => token('not') | token('#') | token('-') | token('~');

  Parser powerExp() => ref0(expBase) & (token('^') & ref0(unaryExp)).optional();

  @override
  Parser expBase() =>
      ref0(literal) |
      ref0(varArg) |
      ref0(functionDef) |
      ref0(primaryExp) |
      ref0(tableConstructor);

  // subclasses must override this
  Parser functionDef() => ref0(literal);

  Parser binOp() =>
      token('+') |
      token('-') |
      token('*') |
      token('//') |
      token('/') |
      token('^') |
      token('%') |
      token('&') |
      token('|') |
      token('>>') |
      token('<<') |
      token('..') |
      token('<=') |
      token('>=') |
      token('==') |
      token('~=') |
      token('<') |
      token('>') |
      token('~') |
      token('and') |
      token('or');

  Parser unOp() => token('-') | token('not') | token('#') | token('~');
}

class LuaStatGrammarDefinition extends LuaExpGrammarDefinition {
  @override
  Parser start() =>
      ref0(utf8Bom).optional() & ref0(firstLine).optional() & ref0(chunk).end();

  Parser utf8Bom() => string(r'\xEF\xBB\xBF');

  Parser firstLine() =>
      char('#') & newline().neg().star() & newline().optional();

  Parser chunk() => ref0(block);

  Parser block() => ref0(stat).star() & ref0(returnStat).optional();

  Parser stat() =>
      ref0(emptyStat) |
      ref0(assignStat) |
      ref0(functionCallStat) |
      ref0(labelStat) |
      ref0(breakStat) |
      ref0(gotoStat) |
      ref0(doStat) |
      ref0(whileStat) |
      ref0(repeatStat) |
      ref0(ifStat) |
      ref0(forStat) |
      ref0(forInStat) |
      ref0(functionStat) |
      ref0(localFunctionStat) |
      ref0(localAssignStat);

  Parser emptyStat() => token(';');

  Parser assignStat() => ref0(varList) & token('=') & ref0(expList);

  Parser functionCallStat() => ref0(primaryExp);

  Parser labelStat() => token('::') & ref0(name) & token('::');

  Parser breakStat() => token('break');

  Parser gotoStat() => token('goto') & ref0(name);

  Parser doStat() => token('do') & ref0(block) & token('end');

  Parser whileStat() =>
      token('while') & ref0(exp) & token('do') & ref0(block) & token('end');

  Parser repeatStat() =>
      token('repeat') & ref0(block) & token('until') & ref0(exp);

  Parser ifStat() =>
      token('if') &
      ref0(exp) &
      token('then') &
      ref0(block) &
      ref0(ifElseIf).star() &
      ref0(ifElse).optional() &
      token('end');

  Parser ifElseIf() =>
      token('elseif') & ref0(exp) & token('then') & ref0(block);

  Parser ifElse() => token('else') & ref0(block);

  Parser forStat() =>
      token('for') &
      ref0(name) &
      token('=') &
      ref0(exp) &
      token(',') &
      ref0(exp) &
      ref0(forStep).optional() &
      token('do') &
      ref0(block) &
      token('end');

  Parser forStep() => token(',') & ref0(exp);

  Parser forInStat() =>
      token('for') &
      ref0(nameList) &
      token('in') &
      ref0(expList) &
      token('do') &
      ref0(block) &
      token('end');

  Parser functionStat() => token('function') & ref0(funcName) & ref0(funcBody);

  Parser localFunctionStat() =>
      token('local') & token('function') & ref0(name) & ref0(funcBody);

  Parser localAssignStat() =>
      token('local') &
      ref0(attrNameList) &
      (token('=') & ref0(expList)).optional();

  Parser attrNameList() => ref0(attrName).plusSeparated(token(','));

  Parser attrName() => ref0(name) & ref0(attr).optional();

  Parser attr() => token('<') & ref0(name) & token('>');

  Parser returnStat() =>
      token('return') & ref0(expList).optional() & token(';').optional();

  Parser funcNameBase() => ref0(name).plusSeparated(token('.'));

  Parser funcNameSuffix() => token(':') & ref0(name);

  Parser funcName() => ref0(funcNameBase) & funcNameSuffix().optional();

  Parser varList() => ref0(primaryExp).plusSeparated(token(','));

  Parser nameList() => ref0(name).plusSeparated(token(','));

  @override
  Parser functionDef() => token('function') & ref0(funcBody);

  Parser funcBody() =>
      token('(') &
      ref0(paramList).optional() &
      token(')') &
      ref0(block) &
      token('end');

  Parser paramList() => ref0(varParamList) | ref0(namedParamList);

  Parser varParamList() => ref0(varArg);

  Parser namedParamList() =>
      ref0(nameList) & (token(',') & ref0(varArg)).optional();

  @override
  Parser fieldValue() => ref0(exp);
}

class LuaCommentGrammarDefinition extends LuaStatGrammarDefinition {
  @override
  Parser ignore() => (whitespace() | newline() | ref0(comment)).plus();

  Parser comment() {
    var p = ref1(longComment, 0);
    for (var i = LuaGrammarDefinition.supportedLongBracketLevel; i > 0; i--) {
      p = p | ref1(longComment, i);
    }
    return p | ref0(invalidLongComment) | ref0(shortComment);
  }

  Parser shortComment() =>
      string('--') & newline().neg().star() & newline().optional();

  Parser longComment(int level) =>
      string('--') &
      ref1(longOpenBracket, level) &
      (whitespace() | newline() | ref1(longCloseBracket, level).neg()).star() &
      ref1(longCloseBracket, level);

  Parser invalidLongComment() =>
      rawToken('--') &
      char('[') &
      char('=').star() &
      char('[') &
      any().star().end();

  @override
//Parser start() => ref0(ignore) & ref0(chunk) & ref0(ignore).end();
  Parser block() =>
      ref0(ignore).optional() &
      ref0(stat).star() &
      ref0(returnStat).optional() &
      ref0(ignore).optional();
}

class LuaGrammarDefinition extends LuaCommentGrammarDefinition {
  static const supportedLongBracketLevel = 10;
}
