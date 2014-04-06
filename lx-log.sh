#!/usr/bin/php
<?php


$sInput = getInput();

switch ($sInput) {
	case '--help':
		showHelp();
		break;
	default:
		addLog($sInput);
	case '':
		showLast();
}

function getInput() {
	$aInput = $_SERVER['argv'];
	array_shift($aInput);
	return implode(" ", $aInput);
}

function addLog($sLog) {
	$sEntry = sprintf("%s\t%s", date('Y-m-d H:i:s'), $sLog);
	$filepath = getFilename();
	$content = implode("\n", array(
		file_get_contents($filepath)
		, $sEntry
	));
	file_put_contents($filepath, $content);
}

function showHelp() {
	writeOutput('lx-log [any [combination [of [words [...]]]]]');
}

function writeOutput($sText) {
	echo $sText . "\n";
	exit;
}

function getFilename() {
	$filename = 'DailyLog.txt';
	$filedir = '/Users/alexarpen/Documents';
	return sprintf('%s/%s', $filedir, $filename);	
}

function showLast() {
	$aLines = explode("\n", file_get_contents(getFilename()));
	$sLast = reset(array_reverse($aLines));
	writeOutput($sLast);
}

