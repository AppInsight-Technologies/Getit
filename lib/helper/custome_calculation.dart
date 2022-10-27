class Calculate{
  double getmargin( mrp, discount) {
    double difference = (mrp -discount);
    double profit = difference / mrp;
    return profit * 100;
  }
}