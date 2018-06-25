import 'package:immutable_state/immutable_state.dart';
import 'package:test/test.dart';

void main() {
  test('current equals initial value', () {
    expect(new Immutable(2).current, 2);
  });

  test('change does not modify current', () {
    var imm = new Immutable(2);
    imm.change((i) => i * 34);
    expect(imm.current, 2);
  });

  test('change triggers onChange', () {
    var imm = new Immutable(2);
    imm.change((i) => i * 34);
    expect(imm.onChange.first, completion(68));
  });

  test('replace triggers onChange', () {
    var imm = new Immutable(2);
    imm.replace(57);
    expect(imm.onChange.first, completion(57));
  });

  test('close() closes onChange', () {
    var imm = new Immutable(2)..close();
    imm.change((i) => 1337);
    expect(imm.onChange.isEmpty, completion(true));
  });
}
