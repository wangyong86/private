package cn.telling.rmi;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

/**
 * 扩展了UnicastRemoteObject类，并实现远程接口 HelloInterface
 * 
 * @ClassName: HelloImpl TODO
 * @author xingle
 * @date 2015-9-28 下午4:38:47
 */
public class HelloImpl extends UnicastRemoteObject implements HelloInterface {
    private String message;

    /**
     * 必须定义构造方法，即使是默认构造方法，也必须把它明确地写出来，因为它必须抛出出RemoteException异常
     * 
     * @param msg
     * @throws RemoteException
     */
    public HelloImpl(String msg) throws RemoteException {
        this.message = msg;
    }

    /**
     * 
     * @Description: TODO
     * @return
     * @throws RemoteException
     * @author xingle
     * @data 2015-9-28 下午4:39:41
     */
    @Override
    public String sayHello() throws RemoteException {
        System.out.println("Called by HelloClient");
        return message;
    }

}
