import 'package:angular2/angular2.dart';

@Pipe(name: 'stringToDate')
class StringToDatePipe extends PipeTransform {
  DateTime transform(String value) => DateTime.parse(value);
}