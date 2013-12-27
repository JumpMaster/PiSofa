$(document).ready(function(){

  var mousedowntime;

  $("#allUp").click(function(){
    $.get( "moveToUp/0", function( data ) {
    });
  });

  $("#allFeet").click(function(){
    $.get( "moveToFeet/0", function( data ) {
    });
  });

  $("#allFlat").click(function(){
    $.get( "moveToFlat/0", function( data ) {
    });
  });

  $("#resetPositions").mouseup(function(){
    $.get( "resetPositions", function( data ) {
    });
  });

  $("#stopAll").click(function(){
    $.get( "stopAll", function( data ) {
    });
  });


  $("#sofa1Up").mousedown(function(){
    $.get( "moveToUp/1", function( data ) {
    });
  });
  $("#sofa1Feet").mousedown(function(){
    $.get( "moveToFeet/1", function( data ) {
    });
  });
  $("#sofa1Flat").mousedown(function(){
    $.get( "moveToFlat/1", function( data ) {
    });
  });

  $("#sofa1ManUp").mousedown(function(){
    $.get( "manUpPress/1", function( data ) {
    });
  });
  $("#sofa1ManUp").mouseup(function(){
    $.get( "manUpRelease/1", function( data ) {
    });
  });

  $("#sofa1ManDown").mousedown(function(){
    $.get( "manDownPress/1", function( data ) {
    });
  });
  $("#sofa1ManDown").mouseup(function(){
    var presstime = (new Date()).getTime() - mousedowntime;
    $.get( "manDownRelease/1", function( data ) {
    });
  });


  $("#sofa2Up").mousedown(function(){
    $.get( "moveToUp/2", function( data ) {
    });
  });
  $("#sofa2Feet").mousedown(function(){
    $.get( "moveToFeet/2", function( data ) {
    });
  });
  $("#sofa2Flat").mousedown(function(){
    $.get( "moveToFlat/2", function( data ) {
    });
  });

  $("#sofa2ManUp").mousedown(function(){
    $.get( "manUpPress/2", function( data ) {
    });
  });
  $("#sofa2ManUp").mouseup(function(){
    $.get( "manUpRelease/2", function( data ) {
    });
  });

  $("#sofa2ManDown").mousedown(function(){
    $.get( "manDownPress/2", function( data ) {
    });
  });
  $("#sofa2ManDown").mouseup(function(){
    $.get( "manDownRelease/2", function( data ) {
    });
  });


  $("#sofa3Up").mousedown(function(){
    $.get( "moveToUp/3", function( data ) {
    });
  });
  $("#sofa3Feet").mousedown(function(){
    $.get( "moveToFeet/3", function( data ) {
    });
  });
  $("#sofa3Flat").mousedown(function(){
    $.get( "moveToFlat/3", function( data ) {
    });
  });

  $("#sofa3ManUp").mousedown(function(){
    $.get( "manUpPress/3", function( data ) {
    });
  });
  $("#sofa3ManUp").mouseup(function(){
    $.get( "manUpRelease/3", function( data ) {
    });
  });

  $("#sofa3ManDown").mousedown(function(){
    $.get( "manDownPress/3", function( data ) {
    });
  });
  $("#sofa3ManDown").mouseup(function(){
    $.get( "manDownRelease/3", function( data ) {
    });
  });
});
