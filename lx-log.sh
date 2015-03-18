#!/usr/bin/php
<?php

define('CMD_ADD', 'add');
define('CMD_AMEND', 'amend'); // Not implemented. @see addLog()
define('CMD_APPEND', 'append');
define('CMD_HELP', 'help');
define('CMD_FILTER', 'filter');

$sInput = getInput();
run($sInput);

function run($sInput) {
	list($sCommand, $sArg) = _parse($sInput);
	switch ($sCommand) {
		case CMD_HELP:
			showHelp();
			break;
		case CMD_ADD:
		case CMD_AMEND:
		case CMD_APPEND:
			if (!empty($sArg)) {
				addLog($sArg, $sCommand);
			} else {
				showLast();
			}
			break;
		case CMD_FILTER:
			filterLog($sArg);
		case 'debug':
		default:
			writeOutput('[DEBUG]' . json_encode((object)array('command' => $sCommand, 'arg' => $sArg)));
			break;
		case '':
	}
}

function _parse($sInput) {
	preg_match_all("/[^\s]*/", $sInput, $aM);
	$aM = array_filter($aM);
	$sCommand = CMD_ADD;
	$sArg = '';
	if (!empty($aM[0][0])) {
		$args = $aM[0];
		$first_arg = $args[0];
		if (0 === strpos($first_arg, '--')) {
			$sCommand = substr(array_shift($args), 2);
		}
		$sArg = implode(' ', $args);
	}
	return array($sCommand, trim($sArg));
}

function getInput() {
	$aInput = $_SERVER['argv'];
	array_shift($aInput);
	return implode(" ", $aInput);
}

function addLog($sLog, $sCommand=null) {
	// @TODO: implement CMD_AMEND
	_processLog($sLog, $sCommand);
	$sEntry = sprintf("%s\t%s", gmdate('D, d M Y H:i:s \G\M\T'), $sLog);
	$filepath = getFilename();
	$separator = ($sCommand == CMD_APPEND) ? ' ' : "\n";
	$content = implode($separator, array(
		file_get_contents($filepath)
		, $sEntry
	));
	file_put_contents($filepath, $content);
}

function showHelp() {
	writeOutput('lx-log [--append|--help|--debug] [any [combination [of [words [...]]]]]');
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
function filterLog($sText) {
	$preg = sprintf('/%s/', $sText);
	$aLines = explode("\n", file_get_contents(getFilename()));
	$aOutput = array();
	foreach ($aLines as $sLine) {
		if (preg_match($preg, $sLine)) {
			// @TODO: Highlight the searched text
			$aOutput[] = $sLine;
		}
	}
	writeOutput(implode("\n", $aOutput));
}


/**
 * Processes a log; and does some actions and also changes to the actual log text before it is logged.
 */
function _processLog(&$sLog, $sCommand) {
	_processLog_task($sLog);
}

/**
 * Task integration: Looks for keywords and if any creats a task out of the log
 * and sets appropriate tags to the task
 */
function _processLog_task(&$sLog) {
	// @FIXME implement
}


