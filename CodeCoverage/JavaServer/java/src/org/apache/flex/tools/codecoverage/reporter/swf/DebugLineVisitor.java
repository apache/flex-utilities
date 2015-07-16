/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

package org.apache.flex.tools.codecoverage.reporter.swf;

import org.apache.flex.abc.ABCConstants;
import org.apache.flex.abc.Pool;
import org.apache.flex.abc.instructionlist.InstructionList;
import org.apache.flex.abc.semantics.ClassInfo;
import org.apache.flex.abc.semantics.ExceptionInfo;
import org.apache.flex.abc.semantics.InstanceInfo;
import org.apache.flex.abc.semantics.Instruction;
import org.apache.flex.abc.semantics.Label;
import org.apache.flex.abc.semantics.MethodBodyInfo;
import org.apache.flex.abc.semantics.MethodInfo;
import org.apache.flex.abc.semantics.Name;
import org.apache.flex.abc.visitors.IClassVisitor;
import org.apache.flex.abc.visitors.IMethodBodyVisitor;
import org.apache.flex.abc.visitors.IMethodVisitor;
import org.apache.flex.abc.visitors.ITraitsVisitor;
import org.apache.flex.abc.visitors.NilABCVisitor;
import org.apache.flex.abc.visitors.NilMethodBodyVisitor;
import org.apache.flex.abc.visitors.NilVisitors;
import org.apache.flex.tools.codecoverage.reporter.CoverageData;

/**
 * Gather all the debug lines and method in a SWF file. 
 * Look for debug_file and debug_line op codes and record them so we know all
 * of possible lines in the SWF that can be executed.
 *
 */
public class DebugLineVisitor extends NilABCVisitor
{

    private final Pool<String> stringPool = new Pool<String>(Pool.DefaultType.HasDefaultZero);
    private final CoverageData coverageData;
    
    // The current class information
    private String currentCtorName;
    private boolean currentClassIsInterface;
    
    /**
     * Constructor
     * 
     * @param coverageData The coverage data where debug lines will be added
     * as unexecuted lines. If a line is already in the coverage data and is
     * marked as executed, then it will remain an executed line.
     */
    public DebugLineVisitor(final CoverageData coverageData)
    {
        this.coverageData = coverageData;
    }

    @Override
    public IClassVisitor visitClass(InstanceInfo iinfo, ClassInfo cinfo)
    {
        currentClassIsInterface = (iinfo.flags & ABCConstants.CONSTANT_ClassInterface) != 0;

        if (currentClassIsInterface)
            currentCtorName = null;
        else
            currentCtorName = "/" + iinfo.name.getBaseName();
        
        return NilVisitors.NIL_CLASS_VISITOR;
    }

    @Override
    public IMethodVisitor visitMethod(MethodInfo minfo)
    {
        return new MethodVisitor();
    }

    @Override
    public void visitPooledString(String s)
    {
        stringPool.add(s);
    }

    /**
     * Visit all the methods in the ABC.
     */
    private class MethodVisitor implements IMethodVisitor
    {
        @Override
        public void visitEnd()
        {
        }

        @Override
        public void visit()
        {
        }

        @Override
        public IMethodBodyVisitor visitBody(MethodBodyInfo mbInfo)
        {
            MethodInfo methodInfo = mbInfo.getMethodInfo();
            String methodName = methodInfo.getMethodName();
            
            // ignore class inits, scripts inits, interfaces, and
            // constructors.
            if (ignoreMethod(methodName))
            {
                return new MyNilMethodBodyVisitor(mbInfo);
            }
            else
            {
                return new MethodBodyVisitor(mbInfo);
            }
        }

        /**
         * Ignore class inits, script inits, interfaces, and constructors.
         * @param methodName The name of the method.
         * @return true to ignore the method, false otherwise.
         */
        private boolean ignoreMethod(String methodName)
        {
            return methodName == null || 
                   methodName.length() == 0 ||
                   currentClassIsInterface ||
                   (currentCtorName != null &&
                   methodName.endsWith(currentCtorName)); 
        }
    }
  
    private class MyNilMethodBodyVisitor extends NilMethodBodyVisitor
    {
        private final MethodBodyInfo mbInfo;
        
        public MyNilMethodBodyVisitor(MethodBodyInfo mbInfo)
        {
            this.mbInfo = mbInfo;
        }

        @Override
        public int visitException(Label from, Label to, Label target, 
                Name exception_type, Name catch_var)
        {
            return  mbInfo.addExceptionInfo(new ExceptionInfo(from, to, target,
                        exception_type, catch_var));
        }
    }
    
    /**
     * Visit all the method bodies in the ABC.
     */
    private class MethodBodyVisitor implements IMethodBodyVisitor
    {
        private final MethodBodyInfo mbInfo;
        private String currentFilename;
        
        public MethodBodyVisitor(MethodBodyInfo mbInfo)
        {
            this.mbInfo = mbInfo;
        }

        @Override
        public void visitEnd()
        {
        }

        @Override
        public void labelCurrent(Label l)
        {
        }

        @Override
        public void labelNext(Label l)
        {
        }

        @Override
        public void visit()
        {
        }

        @Override
        public int visitException(Label from, Label to, Label target, 
                Name exception_type, Name catch_var)
        {
            return  mbInfo.addExceptionInfo(new ExceptionInfo(from, to, target,
                        exception_type, catch_var));
        }

        @Override
        public void visitInstructionList(InstructionList new_list)
        {
            for (Instruction inst : new_list.getInstructions())
            {
                int opcode = inst.getOpcode();
                assert opcode != ABCConstants.OP_debugfile && 
                        opcode != ABCConstants.OP_debugline :
                        "unexpected debug opcode";
            }
        }

        @Override
        public void visitInstruction(int opcode)
        {
            assert opcode != ABCConstants.OP_debugfile && 
                    opcode != ABCConstants.OP_debugline :
                    "unexpected debug opcode";
        }

        @Override
        public void visitInstruction(int opcode, int immediate_operand)
        {
            if (opcode == ABCConstants.OP_debugfile)
            {
                recordDebugFile(immediate_operand);
            }
            else if (opcode == ABCConstants.OP_debugline)
            {
                recordDebugLine(immediate_operand);
            }
        }

        @Override
        public void visitInstruction(int opcode, Object[] operands)
        {
            assert opcode != ABCConstants.OP_debugfile && 
                    opcode != ABCConstants.OP_debugline :
                    "unexpected debug opcode";
        }

        @Override
        public void visitInstruction(int opcode, Object single_operand)
        {
            assert opcode != ABCConstants.OP_debugline :
                    "unexpected debug opcode";

            if (opcode == ABCConstants.OP_debugfile)
                recordDebugFile((String)single_operand);
        }

        @Override
        public void visitInstruction(Instruction instruction)
        {
            int opcode = instruction.getOpcode();
            assert opcode != ABCConstants.OP_debugfile && 
                    opcode != ABCConstants.OP_debugline :
                    "unexpected debug opcode";
        }

        @Override
        public ITraitsVisitor visitTraits()
        {
            return NilVisitors.NIL_TRAITS_VISITOR;
        }

        /**
         * Record a debugfile string
         * 
         * @param filenameIndex Index of filename in the string pool.
         */
        private void recordDebugFile(final int filenameIndex)
        {
            recordDebugFile(stringPool.getValues().get(filenameIndex));
        }

        /**
         * Set the filename in the context for debug lines that
         * come after it.
         * 
         * @param filename The debugfile filename.
         */
        private void recordDebugFile(final String filename)
        {
            currentFilename = filename;
        }
        
        /**
         * Record a debug line into the coverage data.
         * 
         * @param lineNumber The line number of the debug line in 
         * the file that is set by the last debugfile opcode.
         */
        private void recordDebugLine(final int lineNumber)
        {
            assert currentFilename != null : 
                "currentFilename must have been set by a debugFile instruction";

            String methodName =  mbInfo.getMethodInfo().getMethodName(); 
            coverageData.addLine(currentFilename, lineNumber, methodName);
        }
    }
}
