class Employee {
  int employeeID, departmentID;
  String name, address, phoneNumber;

  Employee(this.employeeID, this.name, this.address, this.phoneNumber,
      this.departmentID);

  @override
  String toString() {
    return [
      employeeID.toString(),
      name,
      address,
      phoneNumber,
      departmentID.toString()
    ].toString();
  }
}
