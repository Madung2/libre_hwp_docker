import sys
import os

# LibreOffice 설치 경로에 맞게 수정
os.add_dll_directory(r"C:\Program Files\LibreOffice\program")
sys.path.append(r"C:\Program Files\LibreOffice\program")
sys.path.append(r"C:\Program Files\LibreOffice\program\python-core-3.8.19\lib")

import uno
from com.sun.star.beans import PropertyValue

def convert_to_pdf_with_comments(input_path, output_path):
    local_context = uno.getComponentContext()
    resolver = local_context.ServiceManager.createInstanceWithContext(
        "com.sun.star.bridge.UnoUrlResolver", local_context
    )
    context = resolver.resolve("uno:socket,host=localhost,port=2002;urp;StarOffice.ComponentContext")
    desktop = context.ServiceManager.createInstanceWithContext(
        "com.sun.star.frame.Desktop", context
    )
    
    document = desktop.loadComponentFromURL(f"file:///{input_path}", "_blank", 0, ())
    
    pdf_export_properties = [
        PropertyValue("FilterName", 0, "writer_pdf_Export", 0),
        PropertyValue("Comments", 0, True, 0),
    ]
    
    document.storeToURL(f"file:///{output_path}", tuple(pdf_export_properties))
    document.close(True)

# Example usage
convert_to_pdf_with_comments("C:/Users/tulip/Desktop/libre_hwp_docker/input.docx", "C:/Users/tulip/Desktop/libre_hwp_docker/output.pdf")



# libreoffice 서버모드 실행
#libreoffice --headless --accept="socket,host=localhost,port=2002;urp;"
# 스크립트 실행
#& "C:\Program Files\LibreOffice\program\python.exe" "C:\Users\tulip\Desktop\libre_hwp_docker\with_comment.py"

