
#coding:utf-8
import re
import urllib2
import chardet
from BeautifulSoup import BeautifulSoup

#提取网页正文，放入txt中
def remove_js_css (content):
    """ remove the the javascript and the stylesheet and the comment content (<script>....</script> and <style>....</style> <!-- xxx -->) """
    r = re.compile(r'''<script.*?</script>''',re.I|re.M|re.S)
    s = r.sub ('',content)
    r = re.compile(r'''<style.*?</style>''',re.I|re.M|re.S)
    s = r.sub ('', s)
    r = re.compile(r'''<!--.*?-->''', re.I|re.M|re.S)
    s = r.sub('',s)
    r = re.compile(r'''<meta.*?>''', re.I|re.M|re.S)
    s = r.sub('',s)
    r = re.compile(r'''<ins.*?</ins>''', re.I|re.M|re.S)
    s = r.sub('',s)
    return s

def remove_empty_line (content):
    """remove multi space """
    r = re.compile(r'''^\s+$''', re.M|re.S)
    s = r.sub ('', content)
    r = re.compile(r'''\n+''',re.M|re.S)
    s = r.sub('\n',s)
    return s

def remove_any_tag (s):
    s = re.sub(r'''<[^>]+>''','',s)
    return s.strip()

def remove_any_tag_but_a (s):
    text = re.findall (r'''<a[^r][^>]*>(.*?)</a>''',s,re.I|re.S|re.S)
    text_b = remove_any_tag (s)
    return len(''.join(text)),len(text_b)

def remove_image (s,n=50):
    image = 'a' * n
    r = re.compile (r'''<img.*?>''',re.I|re.M|re.S)
    s = r.sub(image,s)
    return s

def remove_video (s,n=1000):
    video = 'a' * n
    r = re.compile (r'''<embed.*?>''',re.I|re.M|re.S)
    s = r.sub(video,s)
    return s

def sum_max (values):
    cur_max = values[0]
    glo_max = -999999
    left,right = 0,0
    for index,value in enumerate (values):
        cur_max += value
        if (cur_max > glo_max) :
            glo_max = cur_max
            right = index
        elif (cur_max < 0):
            cur_max = 0

    for i in range(right, -1, -1):
        glo_max -= values[i]
        if abs(glo_max < 0.00001):
            left = i
            break
    return left,right+1

def method_1 (content, k=1):
    if not content:
        return None,None,None,None
    tmp = content.split('\n')
    group_value = []
    for i in range(0,len(tmp),k):
        group = '\n'.join(tmp[i:i+k])
        group = remove_image (group)
        group = remove_video (group)
        text_a,text_b= remove_any_tag_but_a (group)
        temp = (text_b - text_a) - 8 
        group_value.append (temp)
    left,right = sum_max (group_value)
    return left,right, len('\n'.join(tmp[:left])), len ('\n'.join(tmp[:right]))

def extract (content):
    content = remove_empty_line(remove_js_css(content))
    left,right,x,y = method_1 (content)
    return '\n'.join(content.split('\n')[left:right])

#输入url，将其新闻页的正文输入txt
def extract_news_content(web_url,file_name):  
    request = urllib2.Request(web_url)  
  
    #在请求加上头信息，伪装成浏览器访问  
    request.add_header('User-Agent','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6')  
    opener = urllib2.build_opener()  
    html= opener.open(request).read()
    infoencode = chardet.detect(html)['encoding']##通过第3方模块来自动提取网页的编码
    if html!=None and infoencode!=None:#提取内容不为空，error.或者用else
        html = html.decode(infoencode,'ignore')
        soup=BeautifulSoup(html)
        content=soup.renderContents()
        content_text=extract(content)#提取新闻网页中的正文部分，化为无换行的一段文字
        content_text= re.sub(" "," ",content_text)
        content_text= re.sub("&gt;","",content_text)
        content_text= re.sub("&quot;",'""',content_text)
        content_text= re.sub("<[^>]+>","",content_text)
        content_text=re.sub("\n","",content_text)
        file = open(file_name,'a')#append
        file.write(content_text)
        file.close()

#抓取百度新闻搜索结果:中文搜索，前10页，url：key=关键词
def search(key_word):
    search_url='http://news.baidu.com/ns?word=key_word&tn=news&from=news&cl=2&rn=20&ct=1' 
    req=urllib2.urlopen(search_url.replace('key_word',key_word))
    real_visited=0
    for count in range(10):#前10页
        html=req.read()
        soup=BeautifulSoup(html)  
        content  = soup.findAll("div", {"class": "result"}) #resultset object
        num = len(content)               
        for i in range(num):
            #先解析出来所有新闻的标题、来源、时间、url
            p_str= content[i].find('a') #if no result then nontype object
            contenttitle=p_str.renderContents()
            contenttitle=contenttitle.decode('utf-8', 'ignore')#need it
            contenttitle= re.sub("<[^>]+>","",contenttitle)
            contentlink=str(p_str.get("href"))
            #存放顺利抓取的url，对比
            visited_url=open(r'D:\\Python27\\visited-cn.txt','r')#是否已经爬过
            visited_url_list=visited_url.readlines()
            visited_url.close()#及时close
            exist=0
            for item in visited_url_list:
                if contentlink==item:
                    exist=1
            if exist!=1:#如果未被访问url
                p_str2= content[i].find('p').renderContents()
                contentauthor=p_str2[:p_str2.find(" &nbsp")]#来源
                contentauthor=contentauthor.decode('utf-8', 'ignore')#时
                contenttime=p_str2[p_str2.find(" &nbsp")+len(" &nbsp")+ 1:]
                contenttime=contenttime.decode('utf-8', 'ignore')
                #filename="D:\\Python27\\newscn\\%d.txt"%(i)
                #file = open(filename,'w')#,一个txt一篇新闻
                real_visited+=1
                file_name=r"D:\\Python27\\newscn\\%d.txt"%(real_visited)
                file = open(file_name,'w')
                file.write(contenttitle.encode('utf-8'))
                file.write(u'\n')
                file.write(contentauthor.encode('utf-8'))
                file.write(u'\n')
                file.write(contenttime.encode('utf-8'))
                file.write(u'\n'+contentlink+u'\n')
                file.close()
                extract_news_content(contentlink,file_name)#还写入文件
                visited_url_list.append(contentlink)#访问之
                visited_url=open(r'D:\\Python27\\visited-cn.txt','a')#标记为已访问，永久存防止程序停止后丢失                
                visited_url.write(contentlink+u'\n')
                visited_url.close()
            if len(visited_url_list)>=120:
                break
            #解析下一页
        if len(visited_url_list)>=120:
            break
        if count==0:
            next_num=0
        else:
            next_num=1
        next_page='http://news.baidu.com'+soup('a',{'href':True,'class':'n'})[next_num]['href'] # search for the next page#翻页
        print next_page
        req=urllib2.urlopen(next_page)

if __name__=='__main__':
    key_word=raw_input('input key word:')
    search(key_word)
