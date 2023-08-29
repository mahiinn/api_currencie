class Currency {
  final String code;
  final String name;

  Currency(this.code, this.name);

  @override
  String toString() {
    return '$code - $name';
  }
}
