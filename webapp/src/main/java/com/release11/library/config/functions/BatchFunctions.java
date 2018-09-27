package com.release11.library.functions;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class BatchFunctions {
    public static List<File>  listFileWithSubfolderFiles (File directory)
    {
        List<File> resultList = new ArrayList<File>();
        File [] files = directory.listFiles();
        for(File file : files)
        {
            if(file.isFile())
            {
                resultList.add(file);
            }
            else if(file.isDirectory())
            {
                resultList.addAll(listFileWithSubfolderFiles(file));
            }
        }
        return resultList;
    }
}
