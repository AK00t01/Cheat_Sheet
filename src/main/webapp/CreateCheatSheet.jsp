<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="Header.jsp" %>
    <title>Create New CheatSheet</title>
    <style>
        .page-shell {
            max-width: 1200px;
        }
        .editor-hero {
            background: linear-gradient(135deg, rgba(15, 111, 255, 0.10), rgba(18, 185, 129, 0.10));
            border: 1px solid rgba(15, 111, 255, 0.12);
        }
        .preview-card {
            transition: all 0.3s ease;
            min-height: 260px;
        }
        .color-swatch {
            width: 38px;
            height: 38px;
            border-radius: 12px;
            border: 2px solid transparent;
            transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
        }
        .color-swatch:hover {
            transform: translateY(-2px) scale(1.04);
        }
        .color-swatch.active {
            border-color: #0f6fff;
            box-shadow: 0 0 0 4px rgba(15, 111, 255, 0.15);
        }
    </style>
</head>
<body class="bg-light">
    <%@ include file="Topbar.jsp" %>

    <div class="container my-5 page-shell">
        <div class="editor-hero rounded-4 p-4 p-lg-5 mb-4 shadow-sm">
            <div class="row align-items-center g-4">
                <div class="col-lg-8">
                    <div class="small text-uppercase fw-bold text-primary mb-2">Create Workspace</div>
                    <h1 class="h2 fw-bold mb-2">Turn a useful shortcut into a polished snippet</h1>
                    <p class="text-muted mb-0">Write clearly, preview instantly, and tune the visual style before you publish. Good snippets are fast to scan and easy to trust.</p>
                </div>
                <div class="col-lg-4">
                    <div class="bg-white rounded-4 p-3 shadow-sm border">
                        <div class="small text-muted mb-2">Before you post</div>
                        <div class="fw-semibold">Use a clear title, one focused topic, and code that can be copied as-is.</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card border-0 shadow-sm">
                    <div class="card-body p-4">
                        <h2 class="fw-bold mb-4"><i class="bi bi-plus-circle text-primary me-2"></i>Create New Snippet</h2>
                        <hr>
                        
                        <form action="creat-sheet" method="post" id="snippetForm">
                            <div class="row">
                                <div class="col-md-7">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Snippet Title</label>
                                        <input type="text" name="title" id="title" class="form-control" placeholder="e.g. Java Loops, CSS Flexbox" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Choose Category</label>
                                        <select name="categoryId" class="form-select">
                                        <c:forEach var="t" items="${sessionScope.categories}">
                                          <option value="${t.categoryId}"> ${t.categoryName}</option>
                                        </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Choose Topic</label>
                                        <input type="text" name="topicName" class="form-control" placeholder="e.g. Java, Python, SQL" required>
                                        <div class="form-text">Please Enter a Topic you want to write!</div>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Content (The Code or Notes)</label>
                                        <textarea name="content" id="content" class="form-control" rows="8" placeholder="Paste your cheat sheet content here..." required></textarea>
                                    </div>
                                    
                                    <div class="row">
                                    <div class="col-md-6 mb-3">
                                       <label class="form-label fw-bold">Background Color</label>
                                             <div class="d-flex flex-wrap gap-2" id="colorOptions">
                                                       <!-- Six Predefined Colors -->
                                                      <button type="button" class="btn color-swatch" data-color="#ffffff" style="background-color: #ffffff; border: 1px solid #ddd;"></button>
                                            <button type="button" class="btn color-swatch" data-color="#f8d7da" style="background-color: #f8d7da;"></button>
						        <button type="button" class="btn color-swatch" data-color="#d1ecf1" style="background-color: #d1ecf1;"></button>
						        <button type="button" class="btn color-swatch" data-color="#d4edda" style="background-color: #d4edda;"></button>
						        <button type="button" class="btn color-swatch" data-color="#fff3cd" style="background-color: #fff3cd;"></button>
						        <button type="button" class="btn color-swatch" data-color="#343a40" style="background-color: #343a40;"></button>
						    </div>
							    <input type="hidden" name="bgColor" id="bgColorInput" value="#ffffff">
							</div>                      
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label fw-bold">Custom Background Color</label>
                                            <input type="color" id="colorPicker" class="form-control form-control-color w-100" value="#ffffff">
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label fw-bold">Font Style</label>
                                            <select name="fontFamily" id="fontPicker" class="form-select">
                                                <option value="'Manrope', sans-serif">Modern Sans</option>
                                                <option value="'JetBrains Mono', monospace">Code (Monospace)</option>
                                                <option value="Georgia, serif">Classic Serif</option>
                                                <option value="'Trebuchet MS', sans-serif">Compact UI</option>
                                            </select>
                                        </div>
                                    </div>

                                    <button type="submit" class="btn btn-primary btn-lg w-100 mt-3 fw-bold">
                                        <i class="bi bi-cloud-arrow-up me-2"></i>Save Snippet
                                    </button>
                                </div>

                                <div class="col-md-5 mt-4 mt-md-0">
                                    <h5 class="text-muted mb-3">Live Preview</h5>
                                    <div id="previewCard" class="card preview-card shadow-sm border p-3">
                                        <div class="card-body">
                                            <h5 id="previewTitle" class="fw-bold">Your Title Here</h5>
                                            <hr>
                                            <pre id="previewContent" style="white-space: pre-wrap;">Content will appear as you type...</pre>
                                        </div>
                                    </div>
                                    <div class="alert alert-info mt-3 small">
                                        <i class="bi bi-info-circle me-1"></i> Make it look exactly how you want!
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const inputTitle = document.getElementById('title');
        const inputContent = document.getElementById('content');
        const previewTitle = document.getElementById('previewTitle');
        const previewContent = document.getElementById('previewContent');
        const previewCard = document.getElementById('previewCard');
        const colorPicker = document.getElementById('colorPicker');
        const fontPicker = document.getElementById('fontPicker');

        inputTitle.addEventListener('input', (e) => {
            previewTitle.innerText = e.target.value || "Your Title Here";
        });

        inputContent.addEventListener('input', (e) => {
            previewContent.innerText = e.target.value || "Content will appear as you type...";
        });

        colorPicker.addEventListener('input', (e) => {
            previewCard.style.backgroundColor = e.target.value;
            bgColorInput.value = e.target.value;
            // Auto-contrast: check if background is dark, make text white
            const rgb = parseInt(e.target.value.substring(1), 16);
            const r = (rgb >> 16) & 0xff;
            const g = (rgb >>  8) & 0xff;
            const b = (rgb >>  0) & 0xff;
            const brightness = 0.2126 * r + 0.7152 * g + 0.0722 * b;
            const textColor = brightness < 128 ? 'white' : 'black';
            previewCard.style.color = textColor;
            previewTitle.style.color = textColor;
            previewContent.style.color = textColor;
            colorButtons.forEach(btn => btn.classList.remove('active'));
        });

        fontPicker.addEventListener('change', (e) => {
            const selectedFont=e.target.value;
            previewTitle.style.fontFamily=selectedFont;
            previewCard.style.fontFamily = selectedFont;
        });
        
        const colorButtons = document.querySelectorAll('.color-swatch');
        const bgColorInput = document.getElementById('bgColorInput');

        colorButtons.forEach(button => {
            button.addEventListener('click', function() {
                const selectedColor = this.getAttribute('data-color');
                
                // 1. Update the hidden input for the Form submission
                bgColorInput.value = selectedColor;
                
                // 2. Update the Preview Card background
                previewCard.style.backgroundColor = selectedColor;
                
                // 3. Auto-contrast logic for text color
                const rgb = parseInt(selectedColor.substring(1), 16);
                const r = (rgb >> 16) & 0xff;
                const g = (rgb >>  8) & 0xff;
                const b = (rgb >>  0) & 0xff;
                const brightness = 0.2126 * r + 0.7152 * g + 0.0722 * b;
                
                const textColor = brightness < 128 ? 'white' : 'black';
                previewCard.style.color = textColor;
                previewTitle.style.color = textColor;
                previewContent.style.color = textColor;
                
                colorPicker.value = selectedColor;
                colorButtons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');
            });
        });

        colorButtons[0].classList.add('active');
    </script>
</body>
</html>
