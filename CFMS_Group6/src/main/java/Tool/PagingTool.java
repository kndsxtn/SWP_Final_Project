/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Tool;

/**
 *
 * @author quang
 */
public class PagingTool {
    private int size, nrpp, index;

    public PagingTool() {
    }

    public PagingTool(int size, int nrpp, int index) {
        this.size = size;
        this.nrpp = nrpp;
        this.index = index;
    }
    
    private int totalPage, start, end, pageStart, pageEnd;

    public void caclPaging(){
        totalPage = size/nrpp + (size%nrpp==0?0:1);
        index = index<0?0:index;
        index = index> totalPage-1?totalPage-1:index;
        start = index * nrpp;
        end = start + nrpp - 1;
        end = end > size - 1 ? size - 1 : end;
        pageStart = index-3<0?0:index-3;
        pageEnd = index+3>totalPage-1?totalPage-1:index+3;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public int getNrpp() {
        return nrpp;
    }

    public void setNrpp(int nrpp) {
        this.nrpp = nrpp;
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public int getTotalPage() {
        return totalPage;
    }

    public void setTotalPage(int totalPage) {
        this.totalPage = totalPage;
    }

    public int getStart() {
        return start;
    }

    public void setStart(int start) {
        this.start = start;
    }

    public int getEnd() {
        return end;
    }

    public void setEnd(int end) {
        this.end = end;
    }

    public int getPageStart() {
        return pageStart;
    }

    public void setPageStart(int pageStart) {
        this.pageStart = pageStart;
    }

    public int getPageEnd() {
        return pageEnd;
    }

    public void setPageEnd(int pageEnd) {
        this.pageEnd = pageEnd;
    }
    
}
