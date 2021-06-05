  // Initialize Firebase


var config = {
    apiKey: "",
    authDomain: "",
    databaseURL: "",
    projectId: "",
    storageBucket: "",
    messagingSenderId: ""
};


firebase.initializeApp(config);
var mirrorId = localStorage.getItem("mirrorId") ;
var tempInK = 373 ;
var timeH = 12 ;
var timeM = 12 ;
var userID ;
var data ;
firebase.database().ref('/linkCodes/' + mirrorId ).on('value' , function(snapshot){
    userID = snapshot.val()

    if(userID == null){
      console.log("🚫User not Logged in")
      document.getElementById("time").style.display = "none" ;
      document.getElementById("date").style.display = "none" ;
      document.getElementById("temp").style.display = "none" ;
      document.getElementById("news").style.display = "none" ;
      document.getElementById("cal").style.display = "none" ;
      document.getElementById("quote").style.display = "none" ;
      document.getElementById("weatherCondition").style.display = "none" ;
      document.getElementById("todoList").style.display = "none" ;
      document.getElementById("qrcode").style.display = "block" ;
    }else{
    console.log("✅User is Logged In") ;
    document.getElementById("qrcode").style.display = "none" ;
    document.getElementById("time").style.display = "block" ;
    document.getElementById("date").style.display = "block" ;
    document.getElementById("temp").style.display = "block" ;
    document.getElementById("news").style.display = "block" ;
    document.getElementById("cal").style.display = "block" ;
    document.getElementById("quote").style.display = "block" ;
    document.getElementById("weatherCondition").style.display = "block" ;
    document.getElementById("todoList").style.display = "block" ;

    console.log(userID) ; 
    firebase.database().ref('/users/' + userID).on('value' ,function(snapshot) {
        data = snapshot.val();

        //Set Custom Quote
        var quoteDiv = document.getElementById('quote') ;
        quoteDiv.innerHTML = "<h1>" + data["customQuote"] + "</h1>" ;

        //set Calender events
        var events = data["calender"] ;
        makeCal = "" ;
        if(events !== undefined ){
          for(var i=0 ; i<events.length ; ++i){
            makeCal = makeCal + "<br>" + events[i] ;
          }
          document.getElementById("cal").innerHTML = makeCal ;
        }else{
          document.getElementById("cal").innerHTML = "" ;
         }
        
        //Set Todo List
        //console.log(data["todoList"]) ;
        var todoList = data["todoList"] ;
        var todoListDiv = document.getElementById("todoList") ;
        var makeToDo = ""  ;
        if(todoList !== undefined){
          for(var i=0 ; i<todoList.length ; ++i){
            makeToDo = makeToDo + "<br>" + todoList[i] ;
          }
          todoListDiv.innerHTML = makeToDo ;
        }else{
          todoListDiv.innerHTML = "" ;
        }

        //Check to show News
        //console.log(data["showNews"]) ;
        if(data["showNews"] == '0'){
          document.getElementById("news").style.display = "none" ;
        }
        if(data["showNews"] == '1'){
          document.getElementById("news").style.display = "block" ;
        }

        //Check to show Calender
        //console.log(data["showCal"]) ;
        if(data["showCal"] == '0'){
          document.getElementById("cal").style.display = "none" ;
        }
        if(data["showCal"] == '1'){
          document.getElementById("cal").style.display = "block" ;
        }

        //Show Temp
        if(tempInK != null) {
          document.getElementById("temp").innerHTML = tempInK ;
          if(data["tempUnit"] == "C"){
            document.getElementById("temp").innerHTML = Math.round(tempInK - 273.15) + "<sup> O </sup> C" ;
          }else {
            document.getElementById("temp").innerHTML = (Math.round((tempInK - 273.15) * (9/5) + 32)) + "<sup> O </sup> F" ;
          }
        }

        //Show time
        getDateTime();
        updatePrefTime() ;

      });
    }
}) ;

function updatePrefTime(){
  if(data["timeFormat"] == '12'){
          
    var meridian = "";
    console.log(Math.floor(timeH/12)) ;
    if(Math.floor(timeH/12)  == 0){
      meridian = "AM" ;
    }else{
      meridian = "PM" ;
    }
    timeH = timeH % 12 ;
    if(timeH == 0 && meridian == "PM"){
      timeH = 12 ;
    }
    document.getElementById("time").innerHTML = timeH + ":" + timeM + " " + meridian ;
    
  }else {
    document.getElementById("time").innerHTML = timeH + ":" + timeM ;
  }
}

function getNews(){
  var nrl = 'https://newsapi.org/v2/top-headlines?country=in&apiKey=<apiKey>' ;
  var Httpreq = new XMLHttpRequest(); // a new request
  Httpreq.open("GET",nrl,false);
  Httpreq.send(null);
  console.log(Httpreq.responseText);  
  var newsData = Httpreq.responseText ;
  var newsJSON = JSON.parse(newsData) ;
  document.getElementById("news").innerHTML = "" ;
  for(var i=0 ; i<5 ; ++i){
    document.getElementById("news").innerHTML = document.getElementById("news").innerHTML + newsJSON["articles"][i]["title"] + "<br>" ;
  }
}

function getTemp(){
  var trl = 'https://api.openweathermap.org/data/2.5/weather?q=indore,in&units=metric&APPID=<appid>' ;
  var Httpreq = new XMLHttpRequest(); // a new request
  Httpreq.open("GET",trl,false);
  Httpreq.send(null);
  console.log(Httpreq.responseText);  
  var tempData = Httpreq.responseText ;
  var tempJSON = JSON.parse(tempData) ;
  if(tempJSON["cod"] != 200){
    console.log("Error") ;
  }else {
    console.log(tempJSON["main"]["temp"]) ;
    tempInK = tempJSON["main"]["temp"] ;
    document.getElementById("weatherCondition").innerHTML = tempJSON["weather"][0]["description"] ;
    document.getElementById("temp").innerHTML = tempJSON["main"]["temp"] + ' <sup>o</sup> C' ;
  }
}

function getDateTime(){
  var date = new Date() ;
  var dateNumber = date.getDate() ;
  var dateDayNum = date.getDay();
  var dateMonthNum = date.getMonth() ;
  var dateDay = "" ;
  switch (dateDayNum) {
    case 0 : dateDay = "Sunday" ;
    break ;
    case 1 : dateDay = "Monday" ;
    break ;
    case 2 : dateDay = "Tuesday" ;
    break ;
    case 3 : dateDay = "Wednesday" ;
    break ;
    case 4 : dateDay = "Thursday" ;
    break ;
    case 5 : dateDay = "Friday" ;
    break ;
    case 6 : dateDay = "Saturday" ;
    break ;
  }

  var dateMonth = "" ;
  switch (dateMonthNum){
    case 0 : dateMonth = "January" ;
    break ;
    case 1 : dateMonth = "Febuary" ;
    break ;
    case 2 : dateMonth = "March" ;
    break ;
    case 3 : dateMonth = "April" ;
    break ;
    case 4 : dateMonth = "May" ;
    break ;
    case 5 : dateMonth = "June" ;
    break ;
    case 6 : dateMonth = "July" ;
    break ;
    case 7 : dateMonth = "August" ;
    break ;
    case 8 : dateMonth = "September" ;
    break ;
    case 9 : dateMonth = "October" ;
    break ;
    case 10 : dateMonth = "November" ;
    break ;
    case 11 : dateMonth = "December" ;
    break ;
  }
  //Set date
  document.getElementById("date").innerHTML = dateDay + ", " + dateNumber  + " " + dateMonth ;
  
  //Set time
  var dateHours = date.getHours() ;
  var dateMin = date.getMinutes() ;
  if(Math.floor(dateMin/10) == 0){
    dateMin = "0" + dateMin ;
  }
  document.getElementById("time").innerHTML = dateHours + ":" + dateMin ; 
  timeH = dateHours ;
  timeM = dateMin ;

}

function updateDateTime() {
  console.log("Updating time") ;
  getDateTime() ;
  updatePrefTime();
}

function updateNewsWeather(){
  console.log("Updating News and weather") ;
  getTemp();
  getNews();
}



window.onload = function(){
    //Initialization code here
    document.getElementById("qrcode").style.display = "none" ;
    //Getting Temperature
    getTemp();

    setInterval(updateDateTime , 1000 * 60) ;
    setInterval(updateNewsWeather , 1000 * 60 * 10) ;

    getDateTime() ;
    //Getting News Data
    getNews();
    
}
