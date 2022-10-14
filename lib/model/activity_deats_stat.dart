class ActivityDeaths {
  String activity;
  int amountDeaths;

  ActivityDeaths(this.activity, this.amountDeaths);

  @override
  String toString() {
    return 'ActivityDeaths{dangerLevel: $activity, amountDeaths: $amountDeaths}';
  }

}