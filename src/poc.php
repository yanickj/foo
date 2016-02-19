<?php
$consumer = new RdKafka\Consumer();
$consumer->setLogLevel(LOG_DEBUG);
$consumer->addBrokers('192.168.56.220:9092');
$topic = $consumer->newTopic('boscovs');
$topic->consumeStart(0, RD_KAFKA_OFFSET_BEGINNING);

while (true) {
    // The first argument is the partition (again).
    // The second argument is the timeout.
    $msg = $topic->consume(0, 1000);
    if ($msg->err) {
        echo $msg->errstr(), "\n";
        break;
    } else {
        $row = json_decode($msg->payload);
        if ($row->brand != 'Aerosoles' and $row->imageLink != '' and $row->availability == 'in stock' and $row->price < 150) {
            echo $msg->payload, "\n";
        }
    }
}
