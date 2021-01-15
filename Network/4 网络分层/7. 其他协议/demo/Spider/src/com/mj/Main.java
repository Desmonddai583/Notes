package com.mj;

import org.apache.commons.io.FileUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.File;
import java.net.URL;

public class Main {
    public static void main(String[] args) throws Exception {
        // 请求网站：https://ext.se.360.cn/webstore/category
        // Jsoup使用CSS选择器来查找元素
        String dir = "C:/Users/MJ/Desktop/imgs/";
        String url = "https://ext.se.360.cn/webstore/category";
        Document doc = Jsoup.connect(url).get();
        Elements eles = doc.select(".applist .appwrap");
        for (Element ele : eles) {
            String img = ele.selectFirst("img").attr("src");
            String title = ele.selectFirst("h3").text();
            String intro = ele.selectFirst(".intro").text();

            // 下载图片
            String filepath = dir + (title + ".png");
            FileUtils.copyURLToFile(new URL(img), new File(filepath));
        }
    }
}
