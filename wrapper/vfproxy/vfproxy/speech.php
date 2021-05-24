<?php

$vName = $_GET['voice'];
$text = $_GET['msg'];
$permitted_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
$randomstring = substr(str_shuffle($permitted_chars), 10, 20);
$arr = array("@gmail.com", "@hotmail.com", "@outlook.com", "@comcast.net", "@aol.com", "@yandex.com", "@icloud.com", "@yahoo.com", "@mail.com");
shuffle($arr);
$domain = $arr[0];
$email1 = $randomstring . $domain;
$email_arr = array($email1, "undefined", "null");
$email = $email_arr[0];
ini_set('user_agent', 'Mozilla/5.0 (Linux; Android 7.0; SM-G930VC Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/58.0.3029.83 Mobile Safari/537.36');

   $url = 'https://api.voiceforge.com:443/swift_engine?HTTP-X-API-KEY=9a272b4&voice=' . $vName . '&msg=' . urlencode($text) . '&email=' . $email;
   
   $filename = md5($vName . $text . date("mdyhisA"));
   
   $wavname = "swift_engine(" . $filename . ").wav";
   
   $mp3name = $filename . ".mp3";
   
   file_put_contents($wavname,file_get_contents($url));
   $command = 'cd ..\lame && lame.exe -q0 -b128 --resample 16 "../vfproxy/' . $wavname . '" "../vfproxy/' . $mp3name . '"';
   shell_exec($command);
   unlink($wavname);
   $file = $mp3name;
   if (isset($_GET['download'])) {
   if (($_GET['download']) == "true") {
	   downloadFile($file);
   }
   } else {
	   playFile($file);
   }
   unlink($mp3name);

function downloadFile($file){
	header('Content-Description: File Transfer');
	header('Content-Type: audio/mp3');
	header('Content-Disposition: attachment; filename="'.basename($file).'"');
	header('Expires: 0');
	header('Cache-Control: must-revalidate');
	header('Pragma: public');
	header('Content-Length: ' . filesize($file));
	readfile($file);
}

function playFile($file){
	header('Content-Type: audio/mp3');
	header('Content-Disposition: inline');
	header('Expires: 0');
	header('Cache-Control: must-revalidate');
	header('Pragma: public');
	header('Content-Length: ' . filesize($file));
	readfile($file);
}
?>
