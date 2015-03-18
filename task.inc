<?php

class LxLog_Processor_Task implements LxLog_Processor {

	public function __construct() {

	}

	public function process($sLog, $sCommand) {
		list($tag, $task) = explode(':', $sLog);
		if (empty($tag)) {
			return false;
		}
		$bin = $this->_getBin();
		if (empty($bin)) {
			throw new LxLog_Exception('Failed to create a task.');
		}
		$task = trim($task);
		// @TODO: for unknown reason 'lx-log' would print 'lx-'
		echo `$bin add tag:$tag $task \(created by l x - l o g \)`;
	}
	
	private function _getBin() {
		return trim(`which task`);
	}
}

