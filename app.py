import streamlit as st
import pymupdf
import io
import zipfile

st.set_page_config(page_title="PDF to Image Converter", page_icon="📄")

st.title("📄 PDF to Image Converter")
st.write("Upload a PDF file and convert its pages into images (PNG or JPG).")

uploaded_file = st.file_uploader("Choose a PDF file", type="pdf")

if uploaded_file is not None:
    col1, col2 = st.columns(2)
    
    with col1:
        image_format = st.selectbox("Select Image Format", ["png", "jpg"])
    
    with col2:
        dpi = st.slider("Select Resolution (DPI)", 72, 600, 200, step=1)

    if st.button("Convert PDF"):
        try:
            with st.spinner("Converting..."):
                # Read the uploaded PDF into memory
                pdf_bytes = uploaded_file.read()
                doc = pymupdf.open(stream=pdf_bytes, filetype="pdf")
                
                total_pages = doc.page_count
                progress_bar = st.progress(0)
                
                # Prepare a buffer for the ZIP file
                zip_buffer = io.BytesIO()
                
                with zipfile.ZipFile(zip_buffer, "a", zipfile.ZIP_DEFLATED, False) as zip_file:
                    for page_index in range(total_pages):
                        page = doc.load_page(page_index)
                        zoom = dpi / 72.0
                        matrix = pymupdf.Matrix(zoom, zoom)
                        
                        # Render page to pixmap
                        # For JPG, we must ensure alpha=False
                        alpha = (image_format == "png")
                        pix = page.get_pixmap(matrix=matrix, alpha=alpha)
                        
                        # Convert pixmap to bytes
                        img_bytes = pix.tobytes(image_format)
                        
                        # Add to zip
                        file_name = f"page_{page_index + 1}.{image_format}"
                        zip_file.writestr(file_name, img_bytes)
                        
                        # Update progress
                        progress_bar.progress((page_index + 1) / total_pages)

                doc.close()
                
                st.success("Conversion complete!")
                
                # Provide download button for the ZIP file
                st.download_button(
                    label="Download Converted Images (ZIP)",
                    data=zip_buffer.getvalue(),
                    file_name=f"{uploaded_file.name.split('.')[0]}_images.zip",
                    mime="application/zip"
                )
                
        except Exception as e:
            st.error(f"An error occurred: {e}")
