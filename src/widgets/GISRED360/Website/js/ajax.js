/**
 * @author ehernanr
 */
var Conexion=false; // Variable que manipula la conexion.

// funcion que realiza la conexion con el objeto XMLHTTP...
function Conectar()
{
  if(window.XMLHttpRequest)
    Conexion=new XMLHttpRequest(); //mozilla
  else if(window.ActiveXObject)
    Conexion=new ActiveXObject("Microsoft.XMLHTTP"); //microsoft
}


