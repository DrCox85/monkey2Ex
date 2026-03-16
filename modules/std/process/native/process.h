
#ifndef BB_STD_PROCESS_H
#define BB_STD_PROCESS_H

#include <bbmonkey.h>

class bbProcess : public bbObject{
public:

	bbProcess();
	~bbProcess();
	
	void discard();
	
	bbFunction<void()> finished;

	bbFunction<void()> stdoutReady;
	bbFunction<void()> stderrReady;//
	
	bbBool start( bbString cmd );
	
	bbInt exitCode();
	
	bbInt stdoutAvail();
	bbInt stderrAvail();//
	
	bbString readStdout();
	bbString readStderr();//
	
	bbInt readStdout( void *buf,bbInt count );
	bbInt readStderr( void *buf,bbInt count );//
	
	bbInt writeStdin( bbString str );
	
	bbInt writeStdin( void *buf,bbInt count );
	
	void sendBreak();
	
	void terminate();
	
private:
	struct Rep;
	
	Rep *_rep;
	
	void gcMark();
};

#endif
