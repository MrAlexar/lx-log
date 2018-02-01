#!/usr/bin/php
<?php

define('CMD_ADD', 'add');
define('CMD_AMEND', 'amend'); // Not implemented. @see addLog()
define('CMD_APPEND', 'append');
define('CMD_HELP', 'help');
define('CMD_FILTER', 'filter');
define('CMD_DATE', 'date'); // Outputs the date that is used for logging
define('CMD_DATAFILE', 'datafile');

prepareEnv();
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
		case CMD_DATE:
			writeOutput(getLoggingDate());
			break;
		case CMD_DATAFILE:
			writeOutput(getFilename());
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
function prepareEnv() {
	define('APP_DATA', $_SERVER['HOME'] . '/.lx-log');
	if (!file_exists(APP_DATA)) {
		mkdir(APP_DATA);
	}
	$filename = getFilename();
	if (!file_exists($filename)) {
		touch($filename);
	}
}
function getInput() {
	$aInput = $_SERVER['argv'];
	array_shift($aInput);
	return implode(" ", $aInput);
}

function addLog($sLog, $sCommand=null) {
	// @TODO: implement CMD_AMEND
	_processLog($sLog, $sCommand);
	$sEntry = sprintf("%s\t%s", getLoggingDate(), $sLog);
	$filepath = getFilename();
	$separator = ($sCommand == CMD_APPEND) ? ' ' : "\n";
	$content = implode($separator, array(
		file_get_contents($filepath)
		, $sEntry
	));
	file_put_contents($filepath, $content);
}
function getLoggingDate() {
	return date('D, d M Y H:i:s T (e)');
}
function showHelp() {
	writeOutput('lx-log [--append|--help|--debug|--datafile|--date] [any [combination [of [words [...]]]]]');
}

function writeOutput($sText) {
	echo $sText . "\n";
	exit;
}

function getFilename() {
	$filename = 'lx-log-main.txt';
	return sprintf('%s/%s', APP_DATA, $filename);
}

function showLast() {
	$aLines = explode("\n", file_get_contents(getFilename()));
	$aLines = array_reverse($aLines);
	$sLast = reset($aLines);
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
	try {
		require_once 'task.inc';
		$oProcessor = new LxLog_Processor_Task;
		if ($oProcessor->isAvailable()) {
			$oProcessor->process($sLog, $sCommand);
		}
		// @TODO Do we want to force using task? It will be skipped if it does not exist at the moment.
	} catch (LxLog_Exception $e) {
		$sLog .= sprintf(' (%s)', $e->getMessage());
	}
}

interface LxLog_Processor {
	public function process($sLog, $sCommand);
}




