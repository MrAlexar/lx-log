#!/usr/bin/php
<?php
$filename = 'DailyLog.txt';
$filedir = '/Users/alexarpen/Documents';

$filepath = sprintf('%s/%s', $filedir, $filename);

$aInput = $_SERVER['argv'];
array_shift($aInput);
$sInput = implode("\s", $aInput);
$sEntry = sprintf("%s\t%s", date('Y-m-d H:i:s'), $sInput);
$content = implode("\n", array(
	file_get_contents($filepath)
	, $sEntry
));

file_put_contents($filepath, $content);

echo sprintf("%s\n", $sEntry);
