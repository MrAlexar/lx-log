<?php

class LxLog_Processor_Task implements LxLog_Processor {

	public function __construct() {

	}

	public function isAvailable() {
		$bin = $this->_getBin();
		return !empty($bin);
	}

	public function process($sLog, $sCommand) {
		$this->_explodeTag($sLog, $tag, $task);
		if (empty($tag)) {
			return false;
		}
		$bin = $this->_getBin();
		if (empty($bin)) {
			throw new LxLog_Exception('Failed to create a task.');
		}
		// @TODO: for unknown reason 'lx-log' would print 'lx-'
		echo `$bin add tag:$tag $task \(created by l x - l o g \)`;
	}
	
	protected function _explodeTag($sLog, &$tag, &$task) {
		preg_match("/^([a-zA-Z]+)\:[\s]*(.+)$/", $sLog, $aM);
		if (3 == count($aM)) {
			$tag = $aM[1];
			$task = $aM[2];
		}
	}

	private function _getBin() {
		return trim(`which task`);
	}
}

