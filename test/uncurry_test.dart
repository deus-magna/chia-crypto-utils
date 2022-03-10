import 'package:chia_utils/chia_crypto_utils.dart';
import 'package:chia_utils/src/clvm/parser.dart';

void main() {
  final program = Program.parse('(a (q 2 (q 2 94 (c 2 (c (c 5 (c (sha256 44 5) (c 11 ()))) (c (a 23 47) (c 95 (c (a 46 (c 2 (c 23 ()))) (c (sha256 639 1407 2943) (c -65 (c 383 (c 767 (c 1535 (c 3071 ())))))))))))) (c (q (((-54 . 61) 70 2 . 51) (60 . 4) 1 1 . -53) ((a 2 (i 5 (q 2 50 (c 2 (c 13 (c (sha256 34 (sha256 44 52) (sha256 34 (sha256 34 (sha256 44 92) 9) (sha256 34 11 (sha256 44 ())))) ())))) (q . 11)) 1) (a (i 11 (q 2 (i (= (a 46 (c 2 (c 19 ()))) 2975) (q 2 38 (c 2 (c (a 19 (c 95 (c 23 (c 47 (c -65 (c 383 (c 27 ()))))))) (c 383 ())))) (q 8)) 1) (q 2 (i 23 (q 2 (i (not -65) (q . 383) (q 8)) 1) (q 8)) 1)) 1) (c (c 5 39) (c (+ 11 87) 119)) 2 (i 5 (q 2 (i (= (a (i (= 17 120) (q . 89) ()) 1) (q . -113)) (q 2 122 (c 2 (c 13 (c 11 (c (c -71 377) ()))))) (q 2 90 (c 2 (c (a (i (= 17 120) (q 4 120 (c (a 54 (c 2 (c 19 (c 41 (c (sha256 44 91) (c 43 ())))))) 57)) (q 2 (i (= 17 36) (q 4 36 (c (sha256 32 41) 57)) (q . 9)) 1)) 1) (c (a (i (= 17 120) (q . 89) ()) 1) (c (a 122 (c 2 (c 13 (c 11 (c 23 ()))))) ())))))) 1) (q 4 () (c () 23))) 1) ((a (i 5 (q 4 9 (a 38 (c 2 (c 13 (c 11 ()))))) (q . 11)) 1) 11 34 (sha256 44 88) (sha256 34 (sha256 34 (sha256 44 92) 5) (sha256 34 (a 50 (c 2 (c 7 (c (sha256 44 44) ())))) (sha256 44 ())))) (a (i (l 5) (q 11 (q . 2) (a 46 (c 2 (c 9 ()))) (a 46 (c 2 (c 13 ())))) (q 11 44 5)) 1) (c (c 40 (c 95 ())) (a 126 (c 2 (c (c (c 47 5) (c 95 383)) (c (a 122 (c 2 (c 11 (c 5 (q ()))))) (c 23 (c -65 (c 383 (c (sha256 1279 (a 54 (c 2 (c 9 (c 2815 (c (sha256 44 45) (c 21 ())))))) 5887) (c 1535 (c 3071 ()))))))))))) 2 42 (c 2 (c 95 (c 59 (c (a (i 23 (q 9 45 (sha256 39 (a 54 (c 2 (c 41 (c 87 (c (sha256 44 -71) (c 89 ())))))) -73)) ()) 1) (c 23 (c 5 (c 767 (c (c (c 36 (c (sha256 124 47 383) ())) (c (c 48 (c (sha256 -65 (sha256 124 21 (+ 383 (- 735 43) 767))) ())) 19)) ()))))))))) 1)) (c (q . 0x72dec062874cd4d3aab892a0906688a1ae412b0109982e1797a170add88bdcdc) (c (q . 0x625c2184e97576f5df1be46c15b2b8771c79e4e6f0aa42d3bfecaebe733f4b8c) (c (q 2 (q 2 (q 2 (i 11 (q 2 (i (= 5 (point_add 11 (pubkey_for_exp (sha256 11 (a 6 (c 2 (c 23 ()))))))) (q 2 23 47) (q 8)) 1) (q 4 (c 4 (c 5 (c (a 6 (c 2 (c 23 ()))) ()))) (a 23 47))) 1) (c (q 50 2 (i (l 5) (q 11 (q . 2) (a 6 (c 2 (c 9 ()))) (a 6 (c 2 (c 13 ())))) (q 11 (q . 1) 5)) 1) 1)) (c (q . 0x94a96f7397ff4acb08b6532fd20bb975a2c350c19216fef4ae9f64499bc59fe919bcf7b531dd80a371ad7858bfb288d2) 1)) 1))))');

  final uncurriedModuleAndArgs = uncurry(program);
  print(uncurriedModuleAndArgs.arguments);
  // print(uncurriedModuleAndArgs.program);
  print('------------');

  const testMnemonic = [
      'elder', 'quality', 'this', 'chalk', 'crane', 'endless',
      'machine', 'hotel', 'unfair', 'castle', 'expand', 'refuse',
      'lizard', 'vacuum', 'embody', 'track', 'crash', 'truth',
      'arrow', 'tree', 'poet', 'audit', 'grid', 'mesh',
  ];

  final masterKeyPair = MasterKeyPair.fromMnemonic(testMnemonic);

  final walletSet = WalletSet.fromPrivateKey(masterKeyPair.masterPrivateKey, 0);

  final puz = getPuzzleFromPk(walletSet.unhardened.childPublicKey);

  final uncurriedpuzAndArgs = uncurry(puz);
  print(uncurriedpuzAndArgs.arguments);

  
}

ProgramAndArguments uncurry(Program progam) {
  final programList = progam.toList();
  if (programList.length != 3) {
    throw Exception('Program is wrong length, should contain 3: (operator, puzzle, arguments)');
  }
  if (programList[0].toInt() != 2) {
    throw Exception('Program is missing apply operator (a)');
  }
  final uncurriedModule = matchQuotedProgram(programList[1]);
  if (uncurriedModule == null) {
    throw Exception('Puzzle did not match expected pattern');
  }
  final uncurriedArgs = matchCurriedArgs(programList[2]);

  return ProgramAndArguments(uncurriedArgs, uncurriedModule);
}

List<Program> matchCurriedArgs(Program program) {
  final result = matchCurriedArgsHelper([], program);
  return result.arguments; 
}

ProgramAndArguments matchCurriedArgsHelper(List<Program> arguments, Program inputProgram) {
  final inputProgramList = inputProgram.toList();
  // base condition
  if (inputProgramList.length == 3 && inputProgramList[0].toInt() == 4 ) {
    final atom = matchQuotedAtom(inputProgramList[1]);
    if(atom == null) {
      final program = matchQuotedProgram(inputProgramList[1]);
      if (program == null) {
        throw Exception('Argument did not match expected patterns');
      }
      arguments.add(program);
    } else {
      arguments.add(atom);
    }
  } else {
    return ProgramAndArguments(arguments, inputProgram);
  }
  return matchCurriedArgsHelper(arguments, inputProgramList[2]);
}

class ProgramAndArguments {
  List<Program> arguments;
  Program program;

  ProgramAndArguments(this.arguments, this.program);
}


Program? matchQuotedAtom(Program program) {
  final cons = program.cons;
  try {
    if (cons.length == 2 && cons[0].toInt() == 1 && cons[1].isAtom) {
      return cons[1];
    }
  } catch (e) {
    return null;
  }
  return null;
}


Program? matchQuotedProgram(Program program) {
  final programList = program.toList();
  try {
    if (programList.length > 2 && programList[0].toInt() == 1 && programList[1].toInt() == 2) {
      return program.cons[1];
    }
    return null;
  } catch (e) {
    return null;
  }
}
