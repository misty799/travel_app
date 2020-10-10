class SearchTrip{
  String name;
  double averageBudget;
SearchTrip(this.name,this.averageBudget);

}
class User{
  bool admin;
  String homeCountry;
  User(this.homeCountry);
  
  Map<String, dynamic> toJson()=>{
    'admin':admin,
    'homeCountry':homeCountry
  };
}