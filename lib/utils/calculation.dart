double calculateTotalPrice(double vehiclePrice, int numberOfDays,
    {double driverCostPerDay = 0.0, double deliveryCost = 0.0}) {
  // Calculate total vehicle cost for the given number of days
  double totalVehicleCost = vehiclePrice * numberOfDays;

  // Calculate total driver cost for the given number of days
  double totalDriverCost = driverCostPerDay * numberOfDays;

  // Total price is the sum of vehicle and driver costs and delivery cost
  double totalPrice = totalVehicleCost + totalDriverCost + deliveryCost;

  return totalPrice;
}

double calculateTotalDeliveryCost(
    double deliveryCostPerKm, double totalDistance) {
  // Calculate total delivery cost based on distance and cost per kilometer
  double totalDeliveryCost = deliveryCostPerKm * totalDistance;
  return totalDeliveryCost;
}
