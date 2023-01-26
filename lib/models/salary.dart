class Salary {

  final int salary;
  late int withoutVAT;

  Salary(this.salary) {
    withoutVAT = (salary * 0.85).toInt(); // VAT is 15%
  }
}