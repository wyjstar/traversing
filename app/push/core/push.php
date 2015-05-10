<?php
$deviceToken = '8690afe1f1f1067b3f45e0a26a3af4eef5391449e8d07073a83220462bf061be'; // masked for security reason
//$deviceToken = 'ab25faef3c290d451a57034397dba52ea653dafb7f6eb614b9303e53ea320a0a'; // masked for security reason
// Passphrase for the private key
$pass = '123456';
 
// Get the parameters from http get or from command line
//$message = $_GET['message'] or $message = $argv[1] or $message = 'Test Message';
//$badge = (int)$_GET['badge'] or $badge = (int)$argv[2];
//$sound = $_GET['sound'] or $sound = $argv[3];
 
// Construct the notification payload
$message = "wang cha";
$body = array();
$body['aps'] = array('alert' => $message);
//if ($badge)
//$body['aps']['badge'] = ";
//if ($sound)
//    $body['aps']['sound'] = $sound;
 
 
/* End of Configurable Items */
$ctx = stream_context_create();
$pem = dirname(__FILE__).'/'.'push_dev.pem';
stream_context_set_option($ctx, 'ssl', 'local_cert', $pem);
// assume the private key passphase was removed.
stream_context_set_option($ctx, 'ssl', 'passphrase', $pass);
 
// for production change the server to ssl://gateway.push.apple.com:219
$fp = stream_socket_client('ssl://gateway.sandbox.push.apple.com:2195', $err, $errstr, 60, STREAM_CLIENT_CONNECT, $ctx);
 
if (!$fp) {
    print "Failed to connect $err $errstr\n";
    return;
}
else {
    print "Connection OK\n";
}
 
$payload = json_encode($body);
$msg = chr(0) . pack("n",32) . pack('H*', str_replace(' ', '', $deviceToken)) . pack("n",strlen($payload)) . $payload;
print "sending message :" . $payload . "\n";
fwrite($fp, $msg);
fclose($fp);
?>
