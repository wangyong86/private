package cn.telling.rmi;

import java.io.Serializable;
import java.rmi.Remote;
import java.rmi.RemoteException;

/**
 * 远程接口必须扩展接口java.rmi.Remote
 * 
 * @ClassName: HelloInterface TODO
 * @author xingle
 * @date 2015-9-28 下午4:37:12
 */
public interface HelloInterface extends Remote, Serializable {
    /**
     * 远程接口方法必须抛出 java.rmi.RemoteException
     */
    public String sayHello() throws RemoteException;;

}
