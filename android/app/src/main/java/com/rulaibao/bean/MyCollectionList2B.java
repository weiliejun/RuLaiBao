package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

/**
 *    我的收藏列表 实体类
 * Created by junde on 2018/5/7.
 */

public class MyCollectionList2B implements IMouldType {

    private String name; // 保险名称
    private String collectionId; // 收藏编号
    private String productId; // 产品编号

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCollectionId() {
        return collectionId;
    }

    public void setCollectionId(String collectionId) {
        this.collectionId = collectionId;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }
}
