<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="Header.jsp" %>
    <title>Edit Snippet: ${detail.title}</title>
    <style>
        .page-shell {
            max-width: 1240px;
        }
        .editor-hero {
            background: linear-gradient(135deg, rgba(15,111,255,0.10), rgba(18,185,129,0.10));
            border: 1px solid rgba(15, 111, 255, 0.12);
        }
        .color-swatch {
            width: 38px;
            height: 38px;
            border-radius: 8px;
            border: 2px solid transparent;
            transition: transform 0.2s, border-color 0.2s;
        }
        .color-swatch:hover {
            transform: scale(1.1);
            border-color: #000;
        }
        .color-swatch.active {
            border-color: #0d6efd;
            box-shadow: 0 0 5px rgba(13, 110, 253, 0.5);
        }
        #previewCard {
            transition: background-color 0.3s ease, font-family 0.3s ease;
            min-height: 300px;
        }
    </style>
</head>
<body class="bg-light">
    <%@ include file="Topbar.jsp" %>

    <div class="container my-5 page-shell">
        <div class="editor-hero rounded-4 p-4 p-lg-5 mb-4 shadow-sm">
            <div class="row align-items-center g-4">
                <div class="col-lg-8">
                    <div class="small text-uppercase fw-bold text-primary mb-2">Edit Workspace</div>
                    <h1 class="h2 fw-bold mb-2">Refine the snippet without losing the original intent</h1>
                    <p class="text-muted mb-0">Update the wording, adjust the visual treatment, and keep the final result easy to scan for the next reader.</p>
                </div>
                <div class="col-lg-4">
                    <div class="bg-white rounded-4 p-3 shadow-sm border">
                        <div class="small text-muted mb-1">Current snippet</div>
                        <div class="fw-semibold text-truncate">${detail.title}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-7">
                <div class="card shadow-sm border-0">
                    <div class="card-header text-white p-3" style="background: linear-gradient(135deg, #0f6fff 0%, #0948b3 100%);">
                        <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>Edit Snippet</h4>
                    </div>
                    <div class="card-body p-4">
                        <form action="edit" method="post" id="editForm">
                            <input type="hidden" name="id" value="${detail.sheetId}">
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">Snippet Title</label>
                                <input type="text" name="title" id="inputTitle" class="form-control" 
                                       value="${detail.title}" placeholder="Enter a catchy title..." required>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Main Category</label>
                                    <select name="categoryId" class="form-select">
                                        <c:forEach var="c" items="${categories}">
                                            <option value="${c.categoryId}" ${c.categoryId == detail.categoryId ? 'selected' : ''}>
                                                ${c.categoryName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Topic (Sub-Category)</label>
                                    <input type="text" name="topicName" class="form-control" 
                                           value="${detail.topic}" placeholder="e.g. Java, Python, CSS" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Content (Code or Notes)</label>
                                <textarea name="content" id="inputContent" class="form-control font-monospace" 
                                          rows="12" required>${detail.content}</textarea>
                            </div>

                            <div class="row align-items-end">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Font Style</label>
                                    <select name="fontFamily" id="inputFont" class="form-select">
                                        <option value="'JetBrains Mono', monospace" ${detail.fontFamily == "'JetBrains Mono', monospace" ? 'selected' : ''}>JetBrains Mono</option>
                                        <option value="'Manrope', sans-serif" ${detail.fontFamily == "'Manrope', sans-serif" ? 'selected' : ''}>Manrope</option>
                                        <option value="Georgia" ${detail.fontFamily == 'Georgia' ? 'selected' : ''}>Georgia (Serif)</option>
                                        <option value="'Trebuchet MS', sans-serif" ${detail.fontFamily == "'Trebuchet MS', sans-serif" ? 'selected' : ''}>Trebuchet MS</option>
                                    </select>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Background Color</label>
                                    <input type="hidden" name="bgColor" id="inputBgColor" value="${detail.bgColor}">
                                    <div class="d-flex flex-wrap gap-2">
                                        <button type="button" class="btn color-swatch" data-color="#ffffff" style="background-color: #ffffff; border: 1px solid #ddd;"></button>
                                        <button type="button" class="btn color-swatch" data-color="#f8d7da" style="background-color: #f8d7da;"></button>
                                        <button type="button" class="btn color-swatch" data-color="#d1ecf1" style="background-color: #d1ecf1;"></button>
                                        <button type="button" class="btn color-swatch" data-color="#d4edda" style="background-color: #d4edda;"></button>
                                        <button type="button" class="btn color-swatch" data-color="#fff3cd" style="background-color: #fff3cd;"></button>
                                        <button type="button" class="btn color-swatch" data-color="#e2e3e5" style="background-color: #e2e3e5;"></button>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                                <a href="view?id=${detail.sheetId}" class="btn btn-outline-secondary px-4">Discard</a>
                                <button type="submit" class="btn btn-primary px-5 fw-bold">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="sticky-top" style="top: 2rem;">
                    <h5 class="fw-bold text-muted mb-3"><i class="bi bi-eye me-2"></i>Live Preview</h5>
                    <div id="previewCard" class="card shadow border-0 p-4" 
                         style="background-color: ${detail.bgColor}; font-family: ${detail.fontFamily};">
                        
                        <div class="mb-2">
                            <span class="badge bg-primary opacity-75 small">Preview Mode</span>
                        </div>
                        
                        <h2 id="previewTitle" class="fw-bold mb-3">${detail.title}</h2>
                        <hr>
                        <pre id="previewContent" style="white-space: pre-wrap;"><code>${detail.content}</code></pre>
                        
                        <div class="mt-4 pt-3 border-top d-flex justify-content-between text-muted small opacity-50">
                            <span><i class="bi bi-person"></i> ${detail.createdBy}</span>
                            <span><i class="bi bi-eye"></i> ${detail.viewCount} views</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0 opacity-50">&copy; 2026 CheatSheet Pro - Coding made easier.</p>
        </div>
    </footer>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Get all elements
            const inputTitle = document.getElementById('inputTitle');
            const inputContent = document.getElementById('inputContent');
            const inputFont = document.getElementById('inputFont');
            const inputBgColor = document.getElementById('inputBgColor');
            
            const previewCard = document.getElementById('previewCard');
            const previewTitle = document.getElementById('previewTitle');
            const previewContent = document.getElementById('previewContent');

            // 1. Title Sync
            inputTitle.addEventListener('input', () => {
                previewTitle.innerText = inputTitle.value || "Snippet Title";
            });

            // 2. Content Sync
            inputContent.addEventListener('input', () => {
                previewContent.innerText = inputContent.value || "Your code will appear here...";
            });

            // 3. Font Sync
            inputFont.addEventListener('change', () => {

                previewTitle.style.fontFamily = inputFont.value;
                previewContent.style.fontFamily = inputFont.value;

            });

            // 4. Color Swatch Logic
            const swatches = document.querySelectorAll('.color-swatch');
            swatches.forEach(swatch => {
                // Highlight the initially active swatch
                if(swatch.getAttribute('data-color') === inputBgColor.value) {
                    swatch.classList.add('active');
                }

                swatch.addEventListener('click', function() {
                    const selectedColor = this.getAttribute('data-color');
                    
                    // Update Preview
                    previewCard.style.backgroundColor = selectedColor;
                    
                    // Update Hidden Input for form submission
                    inputBgColor.value = selectedColor;
                    
                    // UI Polish: Update active state
                    swatches.forEach(s => s.classList.remove('active'));
                    this.classList.add('active');
                });
            });
        });
    </script>
</body>
</html>
